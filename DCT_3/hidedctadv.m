%�������ܣ��������������㷨DCT�����Ϣ����
%�����ʽ������[count,msg,data]=hidedctadv('lenna.jpg','1.jpg','1.txt',1982,1);
%����˵����
%imageΪ����ͼ��
%imagegoalΪ����������Ϣ�����壬����������
%msgΪ�����ص���Ϣ
%keyΪ��Կ�������������ѡ��
%alphaΪ��������������֤�������ȷ��
%countΪ��������Ϣ�ĳ���
%resultΪ���ؽ��
function [count,msg,result]=hidedctadv(image,imagegoal,msg,key,alpha,more)
%��λ��ȡ������Ϣ
frr=fopen(msg,'r');
[msg,count]=fread(frr,'ubit1');
fclose(frr);
data0=imread(image);
%��ͼ�����תΪdouble��
data0=double(data0)/255;
%ȡͼ���һ��������
data=data0(:,:,1);
%��ͼ��ֿ�
T=dctmtx(8);
%�Էֿ�ͼ����DCT�任
DCTrgb=blkproc(data,[8 8],'P1*x*P2',T,T');
DCTrgb0=DCTrgb;
%��������Ŀ�ѡ��,ȷ��ͼ�����׵�ַ
[row,col]=size(DCTrgb);
row=floor(row/8);
col=floor(col/8);
blocks=8*count;
a=zeros([row col]);
[k1,k2]=randinterval(a,blocks,key);
for i=1:blocks
    k1(1,i)=(k1(1,i)-1)*8+1;
    k2(1,i)=(k2(1,i)-1)*8+1;
end
%��ϢǶ��
temp=0;
k=1;
for i=1:blocks
    Tmax=max(DCTrgb(k1(i)+1,k2(i)+5),DCTrgb(k1(i)+3,k2(i)+4));
    Tmin=min(DCTrgb(k1(i)+1,k2(i)+5),DCTrgb(k1(i)+3,k2(i)+4));
    flag1 = Tmax-DCTrgb(k1(i)+6,k2(i)+1);
    flag2 = DCTrgb(k1(i)+6,k2(i)+1)-Tmin;
    disp(i);
    if msg(k,1)==0&&flag1<more
        if flag1>=0
            temp=Tmax;
            if DCTrgb(k1(i)+1,k2(i)+5)==Tmax
                DCTrgb(k1(i)+1,k2(i)+5)=DCTrgb(k1(i)+6,k2(i)+1);
            else
                DCTrgb(k1(i)+3,k2(i)+4)=DCTrgb(k1(i)+6,k2(i)+1);
            end
            DCTrgb(k1(i)+6,k2(i)+1)=temp+alpha;
            k=k+1;
        else
            DCTrgb(k1(i)+6,k2(i)+1)=DCTrgb(k1(i)+6,k2(i)+1)+alpha;
            k=k+1;
        end
        if k==count+1
            break;
        end
    elseif msg(k,1)==0&&flag1>more
        if DCTrgb(k1(i)+6,k2(i)+1)<Tmin
            DCTrgb(k1(i)+6,k2(i)+1)=Tmin;
        end
    elseif msg(k,1)==1&&flag2<more
        if flag2>=0
            temp=Tmin;
            if DCTrgb(k1(i)+1,k2(i)+5)==Tmin
                DCTrgb(k1(i)+1,k2(i)+5)=DCTrgb(k1(i)+6,k2(i)+1);
            else
                DCTrgb(k1(i)+3,k2(i)+4)=DCTrgb(k1(i)+6,k2(i)+1);
            end
            DCTrgb(k1(i)+6,k2(i)+1)=temp-alpha;
            k=k+1;
        else
            DCTrgb(k1(i)+6,k2(i)+1)=DCTrgb(k1(i)+6,k2(i)+1)-alpha;
            k=k+1;
        end
        if k==count+1
            break;
        end
    elseif msg(k,1)==1&&flag2>more
        if DCTrgb(k1(i)+6,k2(i)+1)>Tmax
           DCTrgb(k1(i)+6,k2(i)+1)=Tmax;
        end 
    end
end
disp(k);
if k~=count+1
    disp('��Ϣ�����������ͼ��');
end
%��Ϣд�ر���
DCTrgb1=DCTrgb;
data=blkproc(DCTrgb,[8 8],'P1*x*P2',T',T);
result=data0;
result(:,:,1)=data;
imwrite(result,imagegoal);
