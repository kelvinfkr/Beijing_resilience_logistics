function [f wf zwf]=BGf(C,b)


tic;
threshold = 2;
n=size(C,2);
wf=0;wf0=Inf;
f=zeros(n,n); 
while(1)
      a=ones(n,n)*inf;
      for(i=1:n)
           a(i,i)=0;
           if(toc>threshold)
               f1 = 1;
               break
           end
      end%��������Ȩͼ
      for(i=1:n)
          for(j=1:n)
              if(C(i,j)>0 & f(i,j)==0)
                  a(i,j)=b(i,j);
              elseif(C(i,j)>0 & f(i,j)==C(i,j))
                  a(j,i)=-b(i,j);
              elseif(C(i,j)>0)a(i,j)=b(i,j);
                  a(j,i)=-b(i,j);
              end
          end
      end
      for(i=2:n)
          p(i)=Inf;s(i)=i;
      end %��Ford �㷨�����·, ����ֵ
      for(k=1:n)
          pd=1; %������Ȩͼ��vs ��vt �����·
          for(i=2:n)
              for(j=1:n)
                  if(p(i)>p(j)+a(j,i))
                      p(i)=p(j)+a(j,i);s(i)=j;pd=0;
                  end
              end
          end
           if(toc>threshold)
               f1 = 1;
               break
           end
          if(pd)
              break;
          end
      end %�����·��Ford �㷨����
      if(p(n)==Inf)
          break;
      end %������vs ��vt �����·, �㷨��ֹ�� ע��������С���������ʱ��������Ȩͼ�в��Ậ��Ȩ��·, ���Բ������k=n
    dvt=Inf;
    t=n; %�����������, dvt ��ʾ������
while(1) %���������
      if(a(s(t),t)>0)
          dvtt=C(s(t),t)-f(s(t),t); %ǰ�򻡵�����
      elseif(a(s(t),t)<0)
          dvtt=f(t,s(t));
      end %���򻡵�����
      if(dvt>dvtt)
          dvt=dvtt;
      end
       if(toc>threshold)
               f1 = 1;
               break
           end
      if(s(t)==1)
          break;
      end %��t �ı��Ϊvs ʱ, ��ֹ���������
      t=s(t);
end %��������ǰһ�λ��ϵ���f
pd=0;
if(wf+dvt>=wf0)
    dvt=wf0-wf;pd=1;
end%�������������ڻ����Ԥ��������ֵ
t=n;
while(1) %��������
    if(a(s(t),t)>0)
        f(s(t),t)=f(s(t),t)+dvt; %ǰ�򻡵���
    elseif(a(s(t),t)<0)
        f(t,s(t))=f(t,s(t))-dvt;
    end %���򻡵���
    if(toc>threshold)
               f1 = 1;
               break
           end
    if(s(t)==1)
        break;
    end %��t �ı��Ϊvs ʱ, ��ֹ��������
    t=s(t);end
    if(pd)
        break;
    end%�����������ﵽԤ��������ֵ
    wf=0; 
    for(j=1:n)
        wf=wf+f(1,j);
    end
end %�����������
zwf=0;
for (i=1:n)
    for (j=1:n)
        zwf=zwf+b(i,j)*f(i,j);
    end
end
f; 
