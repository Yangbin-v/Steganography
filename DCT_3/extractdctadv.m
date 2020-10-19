%函数功能：本函数用于DCT隐藏信息的提取
%输入格式举例：tt=extractdctadv('lenna.jpg','2.txt',2020,40)
%参数说明：
%image为已经藏有信息的图象
%permission为图象格式
%msg为提取信息存放的位置
%key为密钥，用来控制随机选块
%count为信息的比特数，由藏入方给出
function result=extractdctadv(image,msg,key,count)
data0=imread(image);
data0=double(data0)/255;
%用图象第一层做提取
data=data0(:,:,1);
%分块做DCT变换
T=dctmtx(8);
DCTcheck=blkproc(data,[8 8],'P1*x*P2',T,T');
%产生随机的块选择,确定图像块的首地址
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
%准备提取并回写信息
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