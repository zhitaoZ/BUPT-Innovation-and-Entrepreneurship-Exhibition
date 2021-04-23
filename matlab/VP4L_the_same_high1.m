%���������ڼ���vp4l��λ�㷨�Ķ�λ���
%�ο����ģ�����˫ƽ����������λ�˹���,VP4L
function result_all=VP4L_the_same_high1(led4_x,led4_y,led3_x,led3_y,led2_x,led2_y,led1_x,led1_y)
% ���ն� camera
f = 8000;%����Ϊ8000um= 8mm
dx = 5.86;dy = 5.86;%ͼ�������ص��������5.86*5.86um
u0=960; v0=600; % ����
A = [1/dx 0 u0;
     0 1/dy v0;
     0 0 1];% �ڲ�������
H = 180;%ʵ��ƽ̨�߶�
led_L =40;%led��40cm
led_W = 40;%led��40cm
led_area = led_L * led_W;%led���
led_num=4;  % led����
led_pos_pixel= [led1_x,led1_y;
                led2_x,led2_y;
                led3_x,led3_y;
                led4_x,led4_y]';%ledͶӰ����������꣬ͨ�������ȡͼƬ����c++��������������˳�����Ϊ��֪���� 2x4 double
led_corner_gs=[0, 0, H;%LED����������ϵ�е�λ������ led_1
               40,0, H;%led_2
               40,40,H;%led_3
               0,40,H]';%led_4
%���ת������
led_pos_img = zeros(3,4);%��ʼ��Ϊ3*4�������
for i=1:led_num
%       led_pos_img(1,i)=dx*(led_pos_pixel(1,i)-u0);
%       led_pos_img(2,i)=dx*(led_pos_pixel(2,i)-v0);
        led_pos_img(:,i)=A\[led_pos_pixel(:,i);1];% LEDͶӰ���image����(camera����ϵ��)   3*4
%     led_pos_img(:,i)=led_pos_cam(:,i)/led_pos_cam(3,i)*f;%�������������ƣ�x=f*Xc/Zc
end
theta1_1=asin(abs(led_pos_img(1,2)-led_pos_img(1,1))/... 
            sqrt((led_pos_img(2,1)-led_pos_img(2,2))^2+(led_pos_img(1,1)-led_pos_img(1,2))^2)); 
        theta1_2=asin(-abs(led_pos_img(1,2)-led_pos_img(1,1))/... 
            sqrt((led_pos_img(2,1)-led_pos_img(2,2))^2+(led_pos_img(1,1)-led_pos_img(1,2))^2)); 

        theta2_1=asin(abs(led_pos_img(1,3)-led_pos_img(1,2))/...
            sqrt((led_pos_img(2,2)-led_pos_img(2,3))^2+(led_pos_img(1,2)-led_pos_img(1,3))^2)); 
        theta2_2=asin(-abs(led_pos_img(1,3)-led_pos_img(1,2))/...
            sqrt((led_pos_img(2,2)-led_pos_img(2,3))^2+(led_pos_img(1,2)-led_pos_img(1,3))^2)); 

        theta3_1=asin(abs(led_pos_img(1,4)-led_pos_img(1,3))/...
            sqrt((led_pos_img(2,3)-led_pos_img(2,4))^2+(led_pos_img(1,3)-led_pos_img(1,4))^2));   
        theta3_2=asin(-abs(led_pos_img(1,4)-led_pos_img(1,3))/...
            sqrt((led_pos_img(2,3)-led_pos_img(2,4))^2+(led_pos_img(1,3)-led_pos_img(1,4))^2));  

        theta4_1=asin(abs(led_pos_img(1,1)-led_pos_img(1,4))/...
            sqrt((led_pos_img(2,4)-led_pos_img(2,1))^2+(led_pos_img(1,4)-led_pos_img(1,1))^2));
        theta4_2=asin(-abs(led_pos_img(1,1)-led_pos_img(1,4))/...
            sqrt((led_pos_img(2,4)-led_pos_img(2,1))^2+(led_pos_img(1,4)-led_pos_img(1,1))^2));

        p1_1=led_pos_img(1,1)*cos(theta1_1)+led_pos_img(2,1)*sin(theta1_1);
        p1_2=led_pos_img(1,1)*cos(theta1_2)+led_pos_img(2,1)*sin(theta1_2);
        if abs(p1_1-(led_pos_img(1,2)*cos(theta1_1)+led_pos_img(2,2)*sin(theta1_1)))<1e-10
            p1=p1_1;
            theta1=theta1_1;
        elseif abs(p1_2-(led_pos_img(1,2)*cos(theta1_2)+led_pos_img(2,2)*sin(theta1_2)))<1e-10
            p1=p1_2;
            theta1=theta1_2;
        end

        p2_1=led_pos_img(1,2)*cos(theta2_1)+led_pos_img(2,2)*sin(theta2_1); 
        p2_2=led_pos_img(1,2)*cos(theta2_2)+led_pos_img(2,2)*sin(theta2_2);
        if abs(p2_1-(led_pos_img(1,3)*cos(theta2_1)+led_pos_img(2,3)*sin(theta2_1)))<1e-10
            p2=p2_1;
            theta2=theta2_1;
        elseif abs(p2_2-(led_pos_img(1,3)*cos(theta2_2)+led_pos_img(2,3)*sin(theta2_2)))<1e-10
            p2=p2_2;
            theta2=theta2_2;
        end

        p3_1=led_pos_img(1,3)*cos(theta3_1)+led_pos_img(2,3)*sin(theta3_1); 
        p3_2=led_pos_img(1,3)*cos(theta3_2)+led_pos_img(2,3)*sin(theta3_2);
        if abs(p3_1-(led_pos_img(1,4)*cos(theta3_1)+led_pos_img(2,4)*sin(theta3_1)))<1e-10
            p3=p3_1;
            theta3=theta3_1;
        elseif abs(p3_2-(led_pos_img(1,4)*cos(theta3_2)+led_pos_img(2,4)*sin(theta3_2)))<1e-10
            p3=p3_2;
            theta3=theta3_2;
        end

        p4_1=led_pos_img(1,4)*cos(theta4_1)+led_pos_img(2,4)*sin(theta4_1); 
        p4_2=led_pos_img(1,4)*cos(theta4_2)+led_pos_img(2,4)*sin(theta4_2);
        if abs(p4_1-(led_pos_img(1,1)*cos(theta4_1)+led_pos_img(2,1)*sin(theta4_1)))<1e-10
            p4=p4_1;
            theta4=theta4_1;
        elseif abs(p4_2-(led_pos_img(1,1)*cos(theta4_2)+led_pos_img(2,1)*sin(theta4_2)))<1e-10
            p4=p4_2;
            theta4=theta4_2;
        end
A_line=[f*cos(theta1);f*cos(theta2);f*cos(theta3);f*cos(theta4)]; % A12,A23,A34,A41
B_line=[f*sin(theta1);f*sin(theta2);f*sin(theta3);f*sin(theta4)]; % B12,B23,B34,B41
C_line=[p1;p2;p3;p4]; %                                            C12,C23,C34,C41
% ���m��n
b11=B_line(1)*C_line(3)-B_line(3)*C_line(1); % �м���� �ο�˫ƽ��������ʽ15
b12=C_line(1)*A_line(3)-C_line(3)*A_line(1);
c1 =A_line(3)*B_line(1)-A_line(1)*B_line(3);

b21=B_line(2)*C_line(4)-B_line(4)*C_line(2); % �м���� �ο�˫ƽ��������ʽ17
b22=C_line(2)*A_line(4)-C_line(4)*A_line(2);
c2 =A_line(4)*B_line(2)-A_line(2)*B_line(4);

A_LS=[b11,b12;b21,b22];

b_LS=[c1;c2];
mn=pinv(A_LS'*A_LS)*A_LS'*b_LS; %[m,n]
m=mn(1);n=mn(2);
% ����LEDƽ����camera����ϵ�з�����
cos_alpha=m/sqrt(m^2+n^2+1);
cos_beta=n/sqrt(m^2+n^2+1);
cos_gama=1/sqrt(m^2+n^2+1);
%normal_efgh=[cos_alpha,cos_beta,cos_gama];
% ��4�������camera���� ʽ19�е�W
WE=[m,n,1;A_line(1),B_line(1),C_line(1);A_line(4),B_line(4),C_line(4)]; % E���W����
WF=[m,n,1;A_line(1),B_line(1),C_line(1);A_line(2),B_line(2),C_line(2)]; % F���W����
WG=[m,n,1;A_line(2),B_line(2),C_line(2);A_line(3),B_line(3),C_line(3)]; % G���W����
WH=[m,n,1;A_line(3),B_line(3),C_line(3);A_line(4),B_line(4),C_line(4)]; % H���W����   
% ������ʽ
det_WE=det(WE);
det_WF=det(WF);
det_WG=det(WG);
det_WH=det(WH);
% ��������ʽ
AC_WE=det_WE*pinv(WE);
AC_WF=det_WF*pinv(WF);
AC_WG=det_WG*pinv(WG);
AC_WH=det_WH*pinv(WH);
% ��qֵ ʽ24
q1_6time=[AC_WE(1,1)/det_WE,AC_WE(2,1)/det_WE,AC_WE(3,1)/det_WE;... % ����׶EFGO�����
          AC_WF(1,1)/det_WF,AC_WF(2,1)/det_WF,AC_WF(3,1)/det_WF;... 
          AC_WG(1,1)/det_WG,AC_WG(2,1)/det_WG,AC_WG(3,1)/det_WG];
q1=1/6*abs(det(q1_6time));

q2_6time=[AC_WF(1,1)/det_WF,AC_WF(2,1)/det_WF,AC_WF(3,1)/det_WF;... % ����׶FGHO�����
          AC_WG(1,1)/det_WG,AC_WG(2,1)/det_WG,AC_WG(3,1)/det_WG;...
          AC_WH(1,1)/det_WH,AC_WH(2,1)/det_WH,AC_WH(3,1)/det_WH];
q2=1/6*abs(det(q2_6time));

q3_6time=[AC_WG(1,1)/det_WG,AC_WG(2,1)/det_WG,AC_WG(3,1)/det_WG;... % ����׶GHEO�����
          AC_WH(1,1)/det_WH,AC_WH(2,1)/det_WH,AC_WH(3,1)/det_WH;...
          AC_WE(1,1)/det_WE,AC_WE(2,1)/det_WE,AC_WE(3,1)/det_WE];
q3=1/6*abs(det(q3_6time));

q4_6time=[AC_WH(1,1)/det_WH,AC_WH(2,1)/det_WH,AC_WH(3,1)/det_WH;...
          AC_WE(1,1)/det_WE,AC_WE(2,1)/det_WE,AC_WE(3,1)/det_WE;... % ����׶HEFO�����
          AC_WF(1,1)/det_WF,AC_WF(2,1)/det_WF,AC_WF(3,1)/det_WF];
q4=1/6*abs(det(q4_6time));
% ��kֵ
k=sqrt(2*led_area/(3*(q1+q2+q3+q4)*sqrt(m^2+n^2+1)));
% ��4�������camera����
p1_xyz=pinv(WE)*[1;0;0]*k;
p2_xyz=pinv(WF)*[1;0;0]*k;
p3_xyz=pinv(WG)*[1;0;0]*k;
p4_xyz=pinv(WH)*[1;0;0]*k;
% LED����4�������camera����
%led_pos_rs_est=[p1_xyz,p2_xyz,p3_xyz,p4_xyz];
% LED����4���ߵ�������ʾ��camera����ϵ�У�
%led_vec_rs_est=[p2_xyz-p1_xyz,p3_xyz-p2_xyz,p4_xyz-p3_xyz,p1_xyz-p4_xyz];            
% ��x��y����ת�� fai��theta
theta_1=asin(-cos_alpha); % fai��theta�ķ�Χ����[-pi/2,pi/2],asinĬ���������Χ����Ҫ����theta_2�ȵļ�����ж�
fai_1=asin(cos_beta/cos(theta_1));
eq1=cos_gama-cos(fai_1)*cos(theta_1);
if eq1<1e-10
    theta=theta_1;
    fai=fai_1;
end  
% ��δ֪��cos(psi) sin(psi) tx ty tz
rot_matrix_x_est = [1,0,0;...
                    0,cos(fai),-sin(fai);...
                    0,sin(fai),cos(fai)];
rot_matrix_y_est = [cos(theta),0,sin(theta);...
                    0,1,0;...
                    -sin(theta),0,cos(theta)];
rox_matrix_yx=rot_matrix_y_est*rot_matrix_x_est;
a1=rox_matrix_yx(1,1);a2=rox_matrix_yx(1,2);a3=rox_matrix_yx(1,3);
b1=rox_matrix_yx(2,1);b2=rox_matrix_yx(2,2);b3=rox_matrix_yx(2,3);
c1=rox_matrix_yx(3,1);c2=rox_matrix_yx(3,2);c3=rox_matrix_yx(3,3);
% ��tz
cont1=p1_xyz(1)*c1+p1_xyz(2)*c2+p1_xyz(3)*c3;
cont2=p2_xyz(1)*c1+p2_xyz(2)*c2+p2_xyz(3)*c3;
cont3=p3_xyz(1)*c1+p3_xyz(2)*c2+p3_xyz(3)*c3;
cont4=p4_xyz(1)*c1+p4_xyz(2)*c2+p4_xyz(3)*c3;
cont=[cont1,cont2,cont3,cont4]; % ��Ϊtz��LED�ĸ߶ȶ���Ψһ�ģ����4����������ͬ,���ֵ
tz=H-mean(cont); % camera��z����
%���� Ax=b ��� x=[cos(psi) sin(psi) tx ty] 
% ��x=[cos(psi) sin(psi) tx ty] ��������С��
% ϵ������
A1=[a1*p1_xyz(1)+a2*p1_xyz(2)+a3*p1_xyz(3),-b1*p1_xyz(1)-b2*p1_xyz(2)-b3*p1_xyz(3),1,0;
    b1*p1_xyz(1)+b2*p1_xyz(2)+b3*p1_xyz(3), a1*p1_xyz(1)+a2*p1_xyz(2)+a3*p1_xyz(3),0,1];
A2=[a1*p2_xyz(1)+a2*p2_xyz(2)+a3*p2_xyz(3),-b1*p2_xyz(1)-b2*p2_xyz(2)-b3*p2_xyz(3),1,0;
    b1*p2_xyz(1)+b2*p2_xyz(2)+b3*p2_xyz(3), a1*p2_xyz(1)+a2*p2_xyz(2)+a3*p2_xyz(3),0,1];
A3=[a1*p3_xyz(1)+a2*p3_xyz(2)+a3*p3_xyz(3),-b1*p3_xyz(1)-b2*p3_xyz(2)-b3*p3_xyz(3),1,0;
    b1*p3_xyz(1)+b2*p3_xyz(2)+b3*p3_xyz(3), a1*p3_xyz(1)+a2*p3_xyz(2)+a3*p3_xyz(3),0,1];
A4=[a1*p4_xyz(1)+a2*p4_xyz(2)+a3*p4_xyz(3),-b1*p4_xyz(1)-b2*p4_xyz(2)-b3*p4_xyz(3),1,0;
    b1*p4_xyz(1)+b2*p4_xyz(2)+b3*p4_xyz(3), a1*p4_xyz(1)+a2*p4_xyz(2)+a3*p4_xyz(3),0,1];
A_para=[A1;A2;A3;A4];
% �Ҳೣ������ ���Ϸ�A1-A4�Ķ�Ӧ��ϵδ֪
b1_line=led_corner_gs(1:2,1);
b2_line=led_corner_gs(1:2,2);
b3_line=led_corner_gs(1:2,3);
b4_line=led_corner_gs(1:2,4);
%b_para=[b1_line,b2_line,b3_line,b4_line];
% ���x����
x_para_12=zeros(led_num,led_num,led_num);
x_para_13=zeros(led_num,led_num,led_num);
x_para_14=zeros(led_num,led_num,led_num);
x_para_23=zeros(led_num,led_num,led_num);
x_para_24=zeros(led_num,led_num,led_num);
x_para_34=zeros(led_num,led_num,led_num);
% b��1,2��������
M_b1=[b1_line;b2_line];
for index_A1=1:led_num
    for index_A2=1:led_num
        if index_A2>index_A1 
            M_A1=[A_para(2*index_A1-1:2*index_A1,:);A_para(2*index_A2-1:2*index_A2,:)];                
            x_para_12(:,index_A1,index_A2)=pinv(M_A1'*M_A1)*M_A1'*M_b1; % ����һ������ȷ��
        end
    end
end
x_para12=[x_para_12(:,1,2),x_para_12(:,[1,2],3),x_para_12(:,1:3,4)]; % ���2ά����
% b��1,3��������
M_b2=[b1_line;b3_line];
for index_A1=1:led_num
    for index_A2=1:led_num
        if index_A2>index_A1
            M_A2=[A_para(2*index_A1-1:2*index_A1,:);A_para(2*index_A2-1:2*index_A2,:)];                
            x_para_13(:,index_A1,index_A2)=pinv(M_A2'*M_A2)*M_A2'*M_b2; % ����һ������ȷ��
        end
    end
end
x_para13=[x_para_13(:,1,2),x_para_13(:,[1,2],3),x_para_13(:,1:3,4)]; % ���2ά����
% b��1,4��������
M_b3=[b1_line;b4_line];
for index_A1=1:led_num
    for index_A2=1:led_num
        if index_A2>index_A1
            M_A3=[A_para(2*index_A1-1:2*index_A1,:);A_para(2*index_A2-1:2*index_A2,:)];                
            x_para_14(:,index_A1,index_A2)=pinv(M_A3'*M_A3)*M_A3'*M_b3; % ����һ������ȷ��
        end
    end
end
x_para14=[x_para_14(:,1,2),x_para_14(:,[1,2],3),x_para_14(:,1:3,4)]; % ���2ά����
% b��2,3��������
M_b4=[b2_line;b3_line];
for index_A1=1:led_num
    for index_A2=1:led_num
        if index_A2>index_A1
            M_A4=[A_para(2*index_A1-1:2*index_A1,:);A_para(2*index_A2-1:2*index_A2,:)];                
            x_para_23(:,index_A1,index_A2)=pinv(M_A4'*M_A4)*M_A4'*M_b4; % ����һ������ȷ��
        end
    end
end
x_para23=[x_para_23(:,1,2),x_para_23(:,[1,2],3),x_para_23(:,1:3,4)]; % ���2ά����
% b��2,4��������
M_b5=[b2_line;b4_line];
for index_A1=1:led_num
    for index_A2=1:led_num
        if index_A2>index_A1
            M_A5=[A_para(2*index_A1-1:2*index_A1,:);A_para(2*index_A2-1:2*index_A2,:)];                
            x_para_24(:,index_A1,index_A2)=pinv(M_A5'*M_A5)*M_A5'*M_b5; % ����һ������ȷ��
        end
    end
end
x_para24=[x_para_24(:,1,2),x_para_24(:,[1,2],3),x_para_24(:,1:3,4)]; % ���2ά����
% b��3,4��������
M_b6=[b3_line;b4_line];
for index_A1=1:led_num
     for index_A2=1:led_num
         if index_A2>index_A1
             M_A6=[A_para(2*index_A1-1:2*index_A1,:);A_para(2*index_A2-1:2*index_A2,:)];                
             x_para_34(:,index_A1,index_A2)=pinv(M_A6'*M_A6)*M_A6'*M_b6; % ����һ������ȷ��
         end
     end
end
x_para34=[x_para_34(:,1,2),x_para_34(:,[1,2],3),x_para_34(:,1:3,4)]; % ���2ά����

%[row_x,col_x]=size(x_para34);
%x_para_all=[x_para12,x_para13,x_para14,x_para23,x_para24,x_para34]; % ���еĽ�ľ���,һ��36���� 

colx=6;
for i_col=1:colx
    aa=x_para12(:,i_col);
    for j_col=1:colx
        bb=x_para13(:,j_col);
        for k_col=1:colx
            cc=x_para14(:,k_col);
            for p_col=1:colx
                dd=x_para23(:,p_col);
                for q_col=1:colx
                    ee=x_para24(:,q_col);
                    for r_col=1:colx
                        ff=x_para34(:,r_col);
                        norm_1=norm(aa-bb);
                        norm_2=norm(aa-cc);
                        norm_3=norm(aa-dd);
                        norm_4=norm(aa-ee);
                        norm_5=norm(aa-ff);
                        norm_6=norm(bb-cc);
                        norm_7=norm(bb-dd);
                        norm_8=norm(bb-ee);
                        norm_9=norm(bb-ff);
                        norm_10=norm(cc-dd);
                        norm_11=norm(cc-ee);
                        norm_12=norm(cc-ff);
                        norm_13=norm(dd-ee);
                        norm_14=norm(dd-ff);
                        norm_15=norm(ee-ff);
                        sum_norm(i_col,j_col,k_col,p_col,q_col,r_col)=...
                            norm_1+norm_2+norm_3+norm_4+norm_5+...
                            norm_6+norm_7+norm_8+norm_9+norm_10+...
                            norm_11+norm_12+norm_13+norm_14+norm_15;
                    end
                end
            end
        end
    end
end

ind=find(sum_norm==min(min(min(min(min(min(sum_norm)))))));
[r1,r2,r3,r4,r5,r6]=ind2sub(size(sum_norm),ind);
x_para1=(x_para12(:,r1)+x_para13(:,r2)+x_para14(:,r3)+x_para23(:,r4)+x_para24(:,r5)+x_para34(:,r6))/6;
% ���ջ�λ��
receiver_pos_est=[x_para1(3:4);tz];
%A12=[A1;A2];b12_line=[b1_line;b2_line];
%x_para12_right=pinv(A12'*A12)*A12'*b12_line;
% ��z����ת�� ˳ʱ�뷽��Ϊ��
%     psi_right=-ang_rot_z; % psi����ȷֵ ����xy�����Ƕȶ���ȷ
cos_psi=x_para1(1);
sin_psi=x_para1(2);      
psi1=acos(cos_psi);
if sin(psi1)==sin_psi
    psi=psi1;
else
    psi=-psi1;
end
%������
result_all = [receiver_pos_est;theta;fai;psi];