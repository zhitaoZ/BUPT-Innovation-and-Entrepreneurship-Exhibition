# -*- coding: utf-8 -*-
# Created by zzt on 2020/11/03

from tkinter import *
import serial
import threading
import time
import sys

DEBUG = 0

pdval = []
dwSampList = []
deManList = []
dataList = []
idList = []
try:
    ser = serial.Serial(port='/dev/ttyACM0', baudrate=115200, timeout=10)
except:
    print("serial open failed!")
    sys.exit(-1)

print("start working now...")

def win_show():
    global imagefile, showText_1, showText_2, showText_3, showText_4
    # 创建窗口
    root = Tk()
    root.title('工业互联网中的高精度可见光定位系统')
    # 创建并添加Canvas
    root.geometry('1000x1000+0+0')  # 窗口大小（‘宽x高+x+y’）
    root.attributes("-topmost", False)  # 窗口在界面最外
    w = root.winfo_screenwidth()
    h = (root.winfo_screenheight())
    cv = Canvas(root, background='black', width=w, height=h)
    imagefile = PhotoImage(file='1-3-3.png')
    cv.create_image(0, 0, anchor='nw', image=imagefile)
    cv.place(x=0, y=0)
    cv.pack()
    showText_1 = StringVar()
    showText_2 = StringVar()
    showText_3 = StringVar()
    showText_4 = StringVar()
    label_1 = Label(root, textvariable=showText_1, bg='silver', fg='red', font=('楷体', 30), width=2, height=5,# s2-2使用bg = drakgray
                    anchor='center', )
    label_2 = Label(root, textvariable=showText_2, bg='silver', fg='red', font=('楷体', 30), width=10, height=1,
                    anchor='center', )
    label_3 = Label(root, textvariable=showText_3, bg='silver', fg='red', font=('楷体', 30), width=2, height=5,
                    anchor='center', )
    label_4 = Label(root, textvariable=showText_4, bg='silver', fg='red', font=('楷体', 30), width=10, height=1,
                    anchor='center', )
# 调整文字显示位置
    label_1.place(x=0.49 * w, y=0.35 * h)#
    label_2.place(x=0.21 * w, y=0.01 * h)
    label_3.place(x=0.005 * w, y=0.35 * h) #label_3.place(x=0.01 * w, y=0.35 * h)
    label_4.place(x=0.21 * w, y=0.87 * h)
    #showText_1.set('原\n料\n装\n载\n区')
    root.mainloop()

# 从arduino模拟端口读取PD转换的相对光强，写入队列pdval
def readArduino(lock):
    global ser
    while True:
        data = ser.read()
        if data:
            # print (int.from_bytes(data, byteorder='big'))
            with lock:
                pdval.append(int.from_bytes(data, byteorder='big'))

# 开始解码，从pdval队列中一次性取20个数值并排序，最大值和最小值的均值作为阈值，小于阈值或小于20，判定为0，否则判定为1，写入dwSampleList队列
def startDecode(lock1, lock2):
    global pdval, dwSampList, dwSampLog
    count = 0
    sortList = [0] * 20
    while True:
        if len(pdval) > 0:
            if count < 20:
                with lock1:
                    sortList[count] = pdval.pop(0)
                count += 1
            else:
                count = 0
                sortedList = sorted(sortList)
                threshold = (sortedList[0] + sortedList[-1]) / 2
                for val in sortList:
                    if val < threshold or val < 20:
                        bit = 0
                    else:
                        bit = 1
                    # print ('val = ', val, ', threshold = ', threshold,  ', bit = ', bit)
                    with lock2:
                        dwSampList.append(bit)
                        # print (dwSampList)
        else:
            time.sleep(0.001)

# 在队列dwSampleList中取3个bit取众数写入deManList
def dwSampThread(lock1, lock2):
    global dwSampList, deManList, deManLog
    l1 = [0, 0, 0]
    decodeCount_1 = 0
    while True:
        while decodeCount_1 < 3:
            try:
                with lock1:
                    bit = dwSampList.pop(0)
            except IndexError:
                time.sleep(0.001)
            else:
                l1[decodeCount_1] = bit
                decodeCount_1 += 1

        if decodeCount_1 >= 3:
            if l1[0] == l1[1] and l1[1] == l1[2]:
                dwBit = l1[1]
                decodeCount_1 -= 3
            elif l1[0] == l1[1] and l1[1] != l1[2]:
                dwBit = l1[1]
                decodeCount_1 -= 2
            elif l1[0] != l1[1] and l1[1] == l1[2]:
                dwBit = l1[1]
                decodeCount_1 -= 4
            elif l1[0] != l1[1] and l1[0] == l1[2]:
                dwBit = l1[0]
                decodeCount_1 -= 3

        # print (str(l1) + ' --> ' + str(dwBit))
        with lock2:
            deManList.append(dwBit)

# deManList队列中取2bit，01->0;10->1;00->1;11->0 写入manBit队列
def deManThread(lock1, lock2):
    global deManList, dataList
    l2 = [0, 0]
    decodeCount_2 = 0
    while True:
        while decodeCount_2 < 2:
            try:
                with lock1:
                    bit = deManList.pop(0)
            except IndexError:
                time.sleep(0.001)
            else:
                l2[decodeCount_2] = bit
                decodeCount_2 += 1

        if decodeCount_2 >= 2:
            if l2[0] == 0 and l2[1] == 1:
                manBit = 0
            elif l2[0] == 1 and l2[1] == 0:
                manBit = 1
            elif l2[0] == 0 and l2[1] == 0:
                manBit = 1
            elif l2[0] == 1 and l2[1] == 1:
                manBit = 0

        decodeCount_2 -= 2

        with lock2:
            dataList.append(manBit)

# manBit队列中先取7位进行同步码判定，再取8位数据位进行id解调，同步码可能反转，进行两种同步码的验证
def getID(lock, lock2):
    global dataList, id_val, idList
    l3 = [0] * 7
    syncLength = 0
    pkt = [0] * 8
    count = 0
    countBit = 0
    check = False

    while True:
        while syncLength < 7:
            try:
                with lock:
                    bit = dataList.pop(0)
            except IndexError:
                time.sleep(0.001)
            else:
                l3[syncLength] = bit
                syncLength += 1

        if syncLength >= 7 and l3[0] == 0 and l3[1] == 0 and l3[2] == 0 and l3[3] == 1 and l3[4] == 1 and l3[5] == 0 and \
                l3[6] == 1:
            bitcount1 = 0
            while bitcount1 < len(pkt):
                try:
                    with lock:
                        bit = dataList.pop(0)
                except IndexError:
                    time.sleep(0.001)
                else:
                    pkt[bitcount1] = bit
                    bitcount1 += 1

            if pkt[:4] == pkt[4:]:
                check = True

            if check:
                count += 1
                weight = 1
                id = 0
                for i in range(4):
                    x = pkt[3 - i]
                    id += x * weight
                    weight *= 2

                id_show = str(id)
                with lock2:
                    idList.append(id_show)
                if DEBUG:
                    print('id = {0}, index = {1}, count = {2}.'.format(id_show, countBit, count))
                    countBit += 15

            syncLength = 0

        elif syncLength >= 7 and l3[0] == 1 and l3[1] == 1 and l3[2] == 1 and l3[3] == 0 and l3[4] == 0 and l3[
            5] == 1 and l3[6] == 0:
            bitcount2 = 0
            while bitcount2 < len(pkt):
                try:
                    with lock:
                        bit = dataList.pop(0)
                except IndexError:
                    time.sleep(0.001)
                else:
                    pkt[bitcount2] = bit
                    bitcount2 += 1

            if pkt[:4] == pkt[4:]:
                check = True

            if check:
                count += 1
                weight = 1
                id = 0
                for i in range(4):
                    x = 1 - pkt[3 - i]
                    id += x * weight
                    weight *= 2

                id_show = str(id)
                with lock2:
                    idList.append(id_show)
                if DEBUG:
                    print('id = {0}, index = {1}, count = {2}.'.format(id_show, countBit, count))
                    countBit += 15

            syncLength = 0

        else:
            if DEBUG:
                countBit += 1
                # print ("move to next bit...,index = {0}".format(countBit))
            l3[:6] = l3[1:]
            syncLength -= 1

# 展示定位结果，通过vnc用笔记本外接显示器显示
def show(lock):
    global idList, showText_1, showText_2, showText_3, showText_4
    count_2 = 0
    l4 = [0, 0, 0]
    while True:
        while count_2 < 3:
            try:
                with lock:
                    i = idList.pop()
            except IndexError:
                time.sleep(0.001)
            else:
                l4[count_2] = i
                count_2 += 1

        if count_2 >= 3:
            if (l4[0] == '1' and l4[1] == '1') or (l4[1] == '1' and l4[2] == '1') or (l4[0] == '1' and l4[2] == '1'):
                showText_1.set('原\n料\n装\n载\n区')
                showText_2.set('')
                showText_3.set('')
                showText_4.set('')
            elif (l4[0] == '2' and l4[1] == '2') or (l4[1] == '2' and l4[2] == '2') or (l4[0] == '2' and l4[2] == '2'):
                showText_1.set('')
                showText_2.set('满载行驶区')
                showText_3.set('')
                showText_4.set('')
            elif (l4[0] == '3' and l4[1] == '3') or (l4[1] == '3' and l4[2] == '3') or (l4[0] == '3' and l4[2] == '3'):
                showText_1.set('')
                showText_2.set('')
                showText_3.set('原\n料\n卸\n载\n区')
                showText_4.set('')
            elif (l4[0] == '4' and l4[1] == '4') or (l4[1] == '4' and l4[2] == '4') or (l4[0] == '4' and l4[2] == '4'):
                showText_1.set('')
                showText_2.set('')
                showText_3.set('')
                showText_4.set('空载行驶区')
        count_2 -= 3

if __name__ == "__main__":
    try:
        lock1 = threading.Lock()
        lock2 = threading.Lock()
        lock3 = threading.Lock()
        lock4 = threading.Lock()
        lock5 = threading.Lock()

        windosThread = threading.Thread(target=win_show, args=())
        readArdThread = threading.Thread(target=readArduino, args=(lock1,))
        decodeThread = threading.Thread(target=startDecode, args=(lock1, lock2))
        dwSampThread = threading.Thread(target=dwSampThread, args=(lock2, lock3))
        deManThread = threading.Thread(target=deManThread, args=(lock3, lock4))
        getIDThread = threading.Thread(target=getID, args=(lock4, lock5))
        showThread = threading.Thread(target=show, args=(lock5,))

        windosThread.start()
        readArdThread.start()
        decodeThread.start()
        dwSampThread.start()
        deManThread.start()
        getIDThread.start()
        showThread.start()

    except KeyboardInterrupt:
        ser.close()
        sys.exit(0)