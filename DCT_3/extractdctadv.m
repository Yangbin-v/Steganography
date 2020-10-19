%�������ܣ�����������DCT������Ϣ����ȡ
%�����ʽ������tt=extractdctadv('lenna.jpg','2.txt',2020,40)
%����˵����
%imageΪ�Ѿ�������Ϣ��ͼ��
%permissionΪͼ���ʽ
%msgΪ��ȡ��Ϣ��ŵ�λ��
%keyΪ��Կ�������������ѡ��
%countΪ��Ϣ�ı��������ɲ��뷽����
function result=extractdctadv(image,msg,key,count)
data0=imread(image);
data0=double(data0)/255;
%��ͼ���һ������ȡ
data=data0(:,:,1);
%�ֿ���DCT�任
T=dctmtx(8);
DCTcheck=blkproc(data,[8 8],'P1*x*P2',T,T');
%��������Ŀ�ѡ��,ȷ��ͼ�����׵�ַ
[row,col]=size(DCTcheck);
row=floor(row/8);
col=floor(col/8);
blocks=8*count;
a=zeros([row col]);
[k1,k2]=randinterval(a,blocks,key);
for i=1:blocks
    k1(1,i)=(k1(1,i)-1)*8+1;
    k2(1,i)=(k2(1,i)-1)*8+1;
end
%׼����ȡ����д��Ϣ
frr=fopen(msg,'w'); 
k=1;
for i=1:blocks
    Tmax=max(DCTcheck(k1(i)+1,k2(i)+5),DCTcheck(k1(i)+3,k2(i)+4));
    Tmin=min(DCTcheck(k1(i)+1,k2(i)+5),DCTcheck(k1(i)+3,k2(i)+4));
    if DCTcheck(k1(i)+6,k2(i)+1)<Tmin
        fwrite(frr,1,'ubit1');
        result(k,1)=1;
        k=k+1;
    elseif DCTcheck(k1(i)+6,k2(i)+1)>Tmax
        fwrite(frr,0,'ubit1');
        result(k,1)=0;
        k=k+1;
    end
    if k==count+1
        break;
    end
end
fclose(frr);