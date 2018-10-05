% �� �ڵ�� ���ʿ��� trial,ä���� ������ �ڵ忡�� outlier ����� �ڵ忡��
%% ������ �ҷ�����
for i=5:38
      data{i}=load(sprintf('txt1/%d.txt',i));%������ �ҷ�����
end

%% ������ �� 31 ä�� �з�(Chset1: �� ä��)  
 for n=5:6 %3��(sub1) ������ data
   rowdata{n} = data{n}(:,2:32);%data 1~31ch 
   cardata{n} = rowdata{n}-repmat(mean(rowdata{n},2), 1, 31);%CAR x���� ä��, y���� �ð� 
    
   Wn=[1 45]; %���ļ��뿪
   [b,a]=butter(3, Wn/512, 'bandpass');%Butter 
   Y{n} = filter(b,a, cardata{n});%filtering
 end

 for num=[7:14,17:30,33:38] %4~7,9~15,17~19��(Sub2~5,7~13,15~17)
   rowdata{num} = data{num}(:,2:32);%data 1~31ch 
   cardata{num} = rowdata{num}-repmat(mean(rowdata{num},2), 1, 31);%CAR x���� ä��, y���� �ð�
    
   Wn=[1 45]; %���ļ��뿪
   [b,a]=butter(3, Wn/512, 'bandpass');%Butter 
   Y{num} = filter(b,a, cardata{num});%filtering
 end

 %% ������ �� trial �з�
       fs=512; % sampling rate
       window =512; %window size
       N=512; %fft resolution --> window size�� ���� ũ��� �����ؾ���
       overlap = window*0.5; %overlap
       
      eo=1;%eyes open ���� �ð���
      ec=8;%eyes closed���� �ð���
   
 for n=5 % 3�� ������(sub1) 1session 
  for trial5 = [1,3:20]% 2�� trial������ �� 19�� trial
     
       op{n}= Y{n}(((trial5-1)*30.5+21-eo)*512:((trial5-1)*30.5+21)*512,:);
       cl{n}= Y{n}(((trial5-1)*30.5+21)*512:((trial5-1)*30.5+21+ec)*512,:);
         
        for chIdx = 1:31
           [so{n}, fo{n}, to{n}, po{n}(:,:,chIdx)] = spectrogram(op{n}(:,chIdx),window,overlap,N,fs);%spectrogramǥ��
           [sc{n}, fc{n}, tc{n}, pc{n}(:,:,chIdx)] = spectrogram(cl{n}(:,chIdx),window,overlap,N,fs);
        end
         mean_po{n}=mean(po{n},2);%�� trial ���� ���
         mean_pc{n}=mean(pc{n},2);
         
         diff{n}=mean_pc{n} - mean_po{n};%��հ� close-open ����
         diff_reall{n}{trial5}=abs(diff{n}(7:16,:));%6~15hz ���� ���캽-0hz�� �ش��ϴ� �͵� �����������(fo or fc�� Ȯ��)
  end
 end
  for n=6 % 3�� ������(sub1) 2session 
  for trial6 = 1:19% 20�� trial������ �� 19�� trial
   
       op{n}= Y{n}(((trial6-1)*30.5+21-eo)*512:((trial6-1)*30.5+21)*512,:);
       cl{n}= Y{n}(((trial6-1)*30.5+21)*512:((trial6-1)*30.5+21+ec)*512,:);
         
        for chIdx = 1:31
           [so{n}, fo{n}, to{n}, po{n}(:,:,chIdx)] = spectrogram(op{n}(:,chIdx),window,overlap,N,fs);%spectrogramǥ��
           [sc{n}, fc{n}, tc{n}, pc{n}(:,:,chIdx)] = spectrogram(cl{n}(:,chIdx),window,overlap,N,fs);
        end
         mean_po{n}=mean(po{n},2);%�� trial ���� ���
         mean_pc{n}=mean(pc{n},2);
         
         diff{n}=mean_pc{n} - mean_po{n};%��հ� close-open ����
         diff_reall{n}{trial6}=abs(diff{n}(7:16,:));%6~15hz ���� ���캽-0hz�� �ش��ϴ� �͵� �����������(fo or fc�� Ȯ��)
  end
 end
 
  for num=[9:12,14,18:20,22,25:27,29:30,33:38] %5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) ������ 1~2 session
                                               %7(sub5),9(sub7),11(sub9)-->2session
                                               %14(sub12)-->1session
     for trial = 1:20%20trial
  
    
       op{num}=Y{num}(((trial-1)*31+21-eo)*512:((trial-1)*31+21)*512,:);
       cl{num}=Y{num}(((trial-1)*31+21.5)*512:((trial-1)*31+21.5+ec)*512,:);
  
        for chIdx = 1:31
           [so{num}, fo{num}, to{num}, po{num}(:,:,chIdx)] = spectrogram(op{num}(:,chIdx),window,overlap,N,fs);
           [sc{num}, fc{num}, tc{num}, pc{num}(:,:,chIdx)] = spectrogram(cl{num}(:,chIdx),window,overlap,N,fs);
        end
  
           mean_po{num}=mean(po{num},2);
           mean_pc{num}=mean(pc{num},2);
    
           diff{num}=mean_pc{num} - mean_po{num}; %��հ� close-open ����
           diff_reall{num}{trial}=abs(diff{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
      end
  end
 
 for num=7 %4��(sub2) ������ 1session
     for trial7 = [1:18,20]%19trial �����ϰ� �� 19�� trial

       op{num}=Y{num}(((trial7-1)*31+21-eo)*512:((trial7-1)*31+21)*512,:);
       cl{num}=Y{num}(((trial7-1)*31+21.5)*512:((trial7-1)*31+21.5+ec)*512,:);
  
        for chIdx = 1:31
           [so{num}, fo{num}, to{num}, po{num}(:,:,chIdx)] = spectrogram(op{num}(:,chIdx),window,overlap,N,fs);
           [sc{num}, fc{num}, tc{num}, pc{num}(:,:,chIdx)] = spectrogram(cl{num}(:,chIdx),window,overlap,N,fs);
        end
  
           mean_po{num}=mean(po{num},2);
           mean_pc{num}=mean(pc{num},2);
    
           diff{num}=mean_pc{num} - mean_po{num}; %��հ� close-open ����
           diff_reall{num}{trial7}=abs(diff{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
 end
 
 for num=8 %4��(sub2) ������ 2session
     for trial8 = [1:13,15,17:20]%14,16�� trial ���� �� 18 trial
    
       op{num}=Y{num}(((trial8-1)*31+21-eo)*512:((trial8-1)*31+21)*512,:);
       cl{num}=Y{num}(((trial8-1)*31+21.5)*512:((trial8-1)*31+21.5+ec)*512,:);
  
        for chIdx = 1:31
           [so{num}, fo{num}, to{num}, po{num}(:,:,chIdx)] = spectrogram(op{num}(:,chIdx),window,overlap,N,fs);
           [sc{num}, fc{num}, tc{num}, pc{num}(:,:,chIdx)] = spectrogram(cl{num}(:,chIdx),window,overlap,N,fs);
        end
  
           mean_po{num}=mean(po{num},2);
           mean_pc{num}=mean(pc{num},2);
    
           diff{num}=mean_pc{num} - mean_po{num}; %��հ� close-open ����
           diff_reall{num}{trial8}=abs(diff{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
 end
 
  for num=13 %7��(sub5) ������ 1session
     for trial13 = [1:7,9:20]%8�� terial ���� �� 19 trial

       op{num}=Y{num}(((trial13-1)*31+21-eo)*512:((trial13-1)*31+21)*512,:);
       cl{num}=Y{num}(((trial13-1)*31+21.5)*512:((trial13-1)*31+21.5+ec)*512,:);
  
        for chIdx = 1:31
           [so{num}, fo{num}, to{num}, po{num}(:,:,chIdx)] = spectrogram(op{num}(:,chIdx),window,overlap,N,fs);
           [sc{num}, fc{num}, tc{num}, pc{num}(:,:,chIdx)] = spectrogram(cl{num}(:,chIdx),window,overlap,N,fs);
        end
  
           mean_po{num}=mean(po{num},2);
           mean_pc{num}=mean(pc{num},2);
    
           diff{num}=mean_pc{num} - mean_po{num}; %��հ� close-open ����
           diff_reall{num}{trial13}=abs(diff{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
 
   for num=17 %9��(sub7) ������ 1session
     for trial17 = 2:20%1�� trial ���� �� 19 trial

       op{num}=Y{num}(((trial17-1)*31+21-eo)*512:((trial17-1)*31+21)*512,:);
       cl{num}=Y{num}(((trial17-1)*31+21.5)*512:((trial17-1)*31+21.5+ec)*512,:);
  
        for chIdx = 1:31
           [so{num}, fo{num}, to{num}, po{num}(:,:,chIdx)] = spectrogram(op{num}(:,chIdx),window,overlap,N,fs);
           [sc{num}, fc{num}, tc{num}, pc{num}(:,:,chIdx)] = spectrogram(cl{num}(:,chIdx),window,overlap,N,fs);
        end
  
           mean_po{num}=mean(po{num},2);
           mean_pc{num}=mean(pc{num},2);
    
           diff{num}=mean_pc{num} - mean_po{num}; %��հ� close-open ����
           diff_reall{num}{trial17}=abs(diff{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
   
  for num=[21,24] %11��(sub9) ������ 1session, 12��(sub10) ������ 2session
     for trial21 = [1:10,12:20]%11�� trial ���� �� 19 trial
  
    
       op{num}=Y{num}(((trial21-1)*31+21-eo)*512:((trial21-1)*31+21)*512,:);
       cl{num}=Y{num}(((trial21-1)*31+21.5)*512:((trial21-1)*31+21.5+ec)*512,:);
  
        for chIdx = 1:31
           [so{num}, fo{num}, to{num}, po{num}(:,:,chIdx)] = spectrogram(op{num}(:,chIdx),window,overlap,N,fs);
           [sc{num}, fc{num}, tc{num}, pc{num}(:,:,chIdx)] = spectrogram(cl{num}(:,chIdx),window,overlap,N,fs);
        end
  
           mean_po{num}=mean(po{num},2);
           mean_pc{num}=mean(pc{num},2);
    
           diff{num}=mean_pc{num} - mean_po{num}; %��հ� close-open ����
           diff_reall{num}{trial21}=abs(diff{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
  
  for num=[23,28] %12��(sub10) ������ 1session, 14��(sub12) ������ 2session
     for trial23 = [1:14,16:20]%15�� trial ���� �� 19 trial
   
    
       op{num}=Y{num}(((trial23-1)*31+21-eo)*512:((trial23-1)*31+21)*512,:);
       cl{num}=Y{num}(((trial23-1)*31+21.5)*512:((trial23-1)*31+21.5+ec)*512,:);
  
        for chIdx = 1:31
           [so{num}, fo{num}, to{num}, po{num}(:,:,chIdx)] = spectrogram(op{num}(:,chIdx),window,overlap,N,fs);
           [sc{num}, fc{num}, tc{num}, pc{num}(:,:,chIdx)] = spectrogram(cl{num}(:,chIdx),window,overlap,N,fs);
        end
  
           mean_po{num}=mean(po{num},2);
           mean_pc{num}=mean(pc{num},2);
    
           diff{num}=mean_pc{num} - mean_po{num}; %��հ� close-open ����
           diff_reall{num}{trial23}=abs(diff{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
  
   for ii= [3:7,9:15,17:19]%2session ��ġ��
     diff_real{ii}=([diff_reall{2*ii-1},diff_reall{2*ii}]);
   end
   %% outlier
     for ii=3
         for iii=[1,3:39]
         xx{ii}{iii}=reshape(diff_real{ii}{iii}, [310 1]); % matrix --> 1-D vector 
         q1{ii}{iii} = quantile(xx{ii}{iii}, 0.25);
         q3{ii}{iii} = quantile(xx{ii}{iii}, 0.75);
         iqr{ii}{iii} = q3{ii}{iii} - q1{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len = 1:length(xx{ii}{iii})
    if (xx{ii}{iii}(len) > q3{ii}{iii}+(iqr{ii}{iii}*3)) || (xx{ii}{iii}(len) < q1{ii}{iii}-(iqr{ii}{iii}*3))
        xx{ii}{iii}(len) = 0;
    end
         end

    noOutMtx{ii}{iii} = reshape(xx{ii}{iii}, [10 31]); %1-D Vector --> matrix
         end
     end
     
      for ii=4
         for iii=[1:18,20:33,35,37:40]
         xx{ii}{iii}=reshape(diff_real{ii}{iii}, [310 1]); % matrix --> 1-D vector 
         q1{ii}{iii} = quantile(xx{ii}{iii}, 0.25);
         q3{ii}{iii} = quantile(xx{ii}{iii}, 0.75);
         iqr{ii}{iii} = q3{ii}{iii} - q1{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len = 1:length(xx{ii}{iii})
    if (xx{ii}{iii}(len) > q3{ii}{iii}+(iqr{ii}{iii}*3)) || (xx{ii}{iii}(len) < q1{ii}{iii}-(iqr{ii}{iii}*3))
        xx{ii}{iii}(len) = 0;
    end
         end

    noOutMtx{ii}{iii} = reshape(xx{ii}{iii}, [10 31]); %1-D Vector --> matrix
         end
          end
     
       for ii=[5:6,10,13,15,17:19]
         for iii=1:40
         xx{ii}{iii}=reshape(diff_real{ii}{iii}, [310 1]); % matrix --> 1-D vector 
         q1{ii}{iii} = quantile(xx{ii}{iii}, 0.25);
         q3{ii}{iii} = quantile(xx{ii}{iii}, 0.75);
         iqr{ii}{iii} = q3{ii}{iii} - q1{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len = 1:length(xx{ii}{iii})
    if (xx{ii}{iii}(len) > q3{ii}{iii}+(iqr{ii}{iii}*3)) || (xx{ii}{iii}(len) < q1{ii}{iii}-(iqr{ii}{iii}*3))
        xx{ii}{iii}(len) = 0;
    end
         end

    noOutMtx{ii}{iii} = reshape(xx{ii}{iii}, [10 31]); %1-D Vector --> matrix
         end
       end
     
     for ii=7
         for iii=[1:7,9:40]
         xx{ii}{iii}=reshape(diff_real{ii}{iii}, [310 1]); % matrix --> 1-D vector 
         q1{ii}{iii} = quantile(xx{ii}{iii}, 0.25);
         q3{ii}{iii} = quantile(xx{ii}{iii}, 0.75);
         iqr{ii}{iii} = q3{ii}{iii} - q1{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len = 1:length(xx{ii}{iii})
    if (xx{ii}{iii}(len) > q3{ii}{iii}+(iqr{ii}{iii}*3)) || (xx{ii}{iii}(len) < q1{ii}{iii}-(iqr{ii}{iii}*3))
        xx{ii}{iii}(len) = 0;
    end
         end

    noOutMtx{ii}{iii} = reshape(xx{ii}{iii}, [10 31]); %1-D Vector --> matrix
         end
     end
     
     for ii=9
         for iii=2:40
         xx{ii}{iii}=reshape(diff_real{ii}{iii}, [310 1]); % matrix --> 1-D vector 
         q1{ii}{iii} = quantile(xx{ii}{iii}, 0.25);
         q3{ii}{iii} = quantile(xx{ii}{iii}, 0.75);
         iqr{ii}{iii} = q3{ii}{iii} - q1{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len = 1:length(xx{ii}{iii})
    if (xx{ii}{iii}(len) > q3{ii}{iii}+(iqr{ii}{iii}*3)) || (xx{ii}{iii}(len) < q1{ii}{iii}-(iqr{ii}{iii}*3))
        xx{ii}{iii}(len) = 0;
    end
         end

    noOutMtx{ii}{iii} = reshape(xx{ii}{iii}, [10 31]); %1-D Vector --> matrix
         end
     end
     
      for ii=11
         for iii=[1:10,12:40]
         xx{ii}{iii}=reshape(diff_real{ii}{iii}, [310 1]); % matrix --> 1-D vector 
         q1{ii}{iii} = quantile(xx{ii}{iii}, 0.25);
         q3{ii}{iii} = quantile(xx{ii}{iii}, 0.75);
         iqr{ii}{iii} = q3{ii}{iii} - q1{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len = 1:length(xx{ii}{iii})
    if (xx{ii}{iii}(len) > q3{ii}{iii}+(iqr{ii}{iii}*3)) || (xx{ii}{iii}(len) < q1{ii}{iii}-(iqr{ii}{iii}*3))
        xx{ii}{iii}(len) = 0;
    end
         end

    noOutMtx{ii}{iii} = reshape(xx{ii}{iii}, [10 31]); %1-D Vector --> matrix
         end
      end
     
      for ii=12
         for iii=[1:14,16:30,32:40]
         xx{ii}{iii}=reshape(diff_real{ii}{iii}, [310 1]); % matrix --> 1-D vector 
         q1{ii}{iii} = quantile(xx{ii}{iii}, 0.25);
         q3{ii}{iii} = quantile(xx{ii}{iii}, 0.75);
         iqr{ii}{iii} = q3{ii}{iii} - q1{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len = 1:length(xx{ii}{iii})
    if (xx{ii}{iii}(len) > q3{ii}{iii}+(iqr{ii}{iii}*3)) || (xx{ii}{iii}(len) < q1{ii}{iii}-(iqr{ii}{iii}*3))
        xx{ii}{iii}(len) = 0;
    end
         end

    noOutMtx{ii}{iii} = reshape(xx{ii}{iii}, [10 31]); %1-D Vector --> matrix
         end
      end
     
       for ii=14
         for iii=[1:34,36:40]
         xx{ii}{iii}=reshape(diff_real{ii}{iii}, [310 1]); % matrix --> 1-D vector 
         q1{ii}{iii} = quantile(xx{ii}{iii}, 0.25);
         q3{ii}{iii} = quantile(xx{ii}{iii}, 0.75);
         iqr{ii}{iii} = q3{ii}{iii} - q1{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len = 1:length(xx{ii}{iii})
    if (xx{ii}{iii}(len) > q3{ii}{iii}+(iqr{ii}{iii}*3)) || (xx{ii}{iii}(len) < q1{ii}{iii}-(iqr{ii}{iii}*3))
        xx{ii}{iii}(len) = 0;
    end
         end

    noOutMtx{ii}{iii} = reshape(xx{ii}{iii}, [10 31]); %1-D Vector --> matrix
         end
       end
  %% CC(������)
   %31�� ä�ΰ� 40�� trial�� ����ϴ� 5,6,10,15,17,18,19��(sub3,4,8,11,13,15,16,17) ������
for c = [5:6,10,13,15,17:19]%5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) train�Ǵ� ������
 for e = [5:6,10,13,15,17:19]%5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) test �Ǵ� ������
  for test = 1:40%test �Ǵ� �������� trial
    for train=1:40%train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = [5:6,10,13,15,17:19]%5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) train�Ǵ� ������
 for e = 3%3��(sub1) test �Ǵ� ������
  for test = [1,3:39]%2,40trial ���� 38�� test �Ǵ� �������� trial
    for train=[1,3:39]%2,40trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = [5:6,10,13,15,17:19]%5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) train�Ǵ� ������
 for e = 4%4��(sub2) test �Ǵ� ������
  for test = [1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� test �Ǵ� �������� trial
    for train=[1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = [5:6,10,13,15,17:19]%5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) train�Ǵ� ������
 for e = 7%7��(sub5) test �Ǵ� ������
  for test = [1:7,9:40]%9 trial ���� 39�� test �Ǵ� �������� trial
    for train = [1:7,9:40]%9 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = [5:6,10,13,15,17:19]%5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) train�Ǵ� ������
 for e = 9%9��(sub7) test �Ǵ� ������
  for test = 2:40%1 trial ���� 39�� test �Ǵ� �������� trial
    for train = 2:40%1 trial ���� 39��  train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = [5:6,10,13,15,17:19]%5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) train�Ǵ� ������
 for e = 11%11��(sub9) test �Ǵ� ������
  for test = [1:10,12:40]%11 trial ���� 39�� test �Ǵ� �������� trial
    for train = [1:10,12:40]%11 trial ���� 39��  train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = [5:6,10,13,15,17:19]%5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) train�Ǵ� ������
 for e = 12%12��(sub10) test �Ǵ� ������
  for test = [1:14,16:30,32:40]%15,31 trial ���� 38�� test �Ǵ� �������� trial
    for train = [1:14,16:30,32:40]%15,31 trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = [5:6,10,13,15,17:19]%5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) train�Ǵ� ������
 for e = 14%14��(sub12) test �Ǵ� ������
  for test = [1:34,36:40]%35 trial ���� 39�� test �Ǵ� �������� trial
    for train = [1:34,36:40]%35 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=[5:6,10,13,15,17:19]%5,6,10,15,17,18,19��(sub3,4,8,11,13,15,16,17) ������
    for test=1:40
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/39;% �ڱ� �ڽŰ� �������� mean
    end
end

%31�� ä��, 3��(Sub1) ������ train
%�ڱ��ڽ��� ���� 40��trial����ϴ� �����ڰ� ����
%39,38,37�� trial ����ϴ� �����ڰ� test�� ��� �ش� �����ڿ��� �����ϴ� trial ��������� ��
for c = 3%3��(Sub1) train�Ǵ� ������
 for e = [3,5:6,10,13,15,17:19]%3,5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) test �Ǵ� ������
  for test = [1,3:39]%2,40trial ���� 38�� test �Ǵ� �������� trial
    for train= [1,3:39]%2,40trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 3%3��(Sub1) train�Ǵ� ������
 for e = 4 %4��(sub2) test �Ǵ� ������
  for test = [1,3:18,20:33,35,37:39]%2,19,34,36,40trial ���� 35�� test �Ǵ� �������� trial
    for train = [1,3:18,20:33,35,37:39]%2,19,34,36,40trial ���� 35�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 3%3��(Sub1) train�Ǵ� ������
 for e = 7 %7��(sub5) test �Ǵ� ������
  for test = [1,3:7,9:39]%2,8,40trial ���� 37�� test �Ǵ� �������� trial
    for train = [1,3:7,9:39]%2,8,40trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 3%3��(Sub1) train�Ǵ� ������
 for e = 9 %9��(sub7) test �Ǵ� ������
  for test = 3:39%1,2,40trial ���� 37�� test �Ǵ� �������� trial
    for train = 3:39%1,2,40trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end
     
for c = 3%3��(Sub1) train�Ǵ� ������
 for e = 11 %11��(sub9) test �Ǵ� ������
  for test = [1,3:10,12:39]%2,11,40trial ���� 37�� test �Ǵ� �������� trial
    for train = [1,3:10,12:39]%2,11,40trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 3%3��(Sub1) train�Ǵ� ������
 for e = 12 %12��(sub10) test �Ǵ� ������
  for test = [1,3:14,16:30,32:39]%2,15,31,40trial ���� 36�� test �Ǵ� �������� trial
    for train = [1,3:14,16:30,32:39]%2,15,31,40trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 3%3��(Sub1) train�Ǵ� ������
 for e = 14 %14��(sub12) test �Ǵ� ������
  for test = [1,3:34,36:39]%2,35,40trial ���� 37�� test �Ǵ� �������� trial
    for train = [1,3:34,36:39]%2,35,40trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=3%3��(sub1) ������
    for test=[1,3:39]
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/37;% �ڱ� �ڽŰ� �������� mean
    end
end

%31�� ä��, 4��(Sub2) ������ train
for c = 4%4��(Sub2) train�Ǵ� ������
 for e = [4:6,10,13,15,17:19]%4,5,6,10,13,15,17,18,19��(sub2.3,4,8,11,13,15,16,17) test �Ǵ� ������
  for test = [1:18,20:33,35,37:40]%19,34,36trial ���� 37�� test �Ǵ� �������� trial
    for train= [1:18,20:33,35,37:40]%19,34,36trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 4%4��(Sub2) train�Ǵ� ������
 for e = 3 %3��(sub1) test �Ǵ� ������
  for test = [1,3:18,20:33,35,37:39]%2,19,34,36,40trial ���� 35�� test �Ǵ� �������� trial
    for train = [1,3:18,20:33,35,37:39]%2,19,34,36,40trial ���� 35�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 4%4��(Sub2) train�Ǵ� ������
 for e = 7 %7��(sub5) test �Ǵ� ������
  for test = [1:7,9:18,20:33,35,37:40]%8,19,34,36trial ���� 36�� test �Ǵ� �������� trial
    for train = [1:7,9:18,20:33,35,37:40]%8,19,34,36trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 4%4��(Sub2) train�Ǵ� ������
 for e = 9 %9��(sub7) test �Ǵ� ������
  for test = [2:18,20:33,35,37:40]%1,19,34,36trial ���� 36�� test �Ǵ� �������� trial
    for train =[2:18,20:33,35,37:40]%1,19,34,36trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end
     
for c = 4%4��(Sub2) train�Ǵ� ������
 for e = 11 %11��(sub9) test �Ǵ� ������
  for test = [1:10,12:18,20:33,35,37:40]%11,19,34,36trial ���� 36�� test �Ǵ� �������� trial
    for train = [1:10,12:18,20:33,35,37:40]%11,19,34,36trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 4%4��(Sub2) train�Ǵ� ������
 for e = 12 %12��(sub10) test �Ǵ� ������
  for test = [1:14,16:18,20:30,32:33,35,37:40]%15,19,31,34,36trial ���� 35�� test �Ǵ� �������� trial
    for train = [1:14,16:18,20:30,32:33,35,37:40]%15,19,31,34,36trial ���� 35�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 4%4��(Sub2) train�Ǵ� ������
 for e = 14 %14��(sub12) test �Ǵ� ������
  for test = [1:18,20:33,37:40]%19,34,35,36trial ���� 36�� test �Ǵ� �������� trial
    for train = [1:18,20:33,37:40]%19,34,35,36trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=4%4��(sub2) ������
    for test=[1:18,20:33,35,37:40]
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/36;% �ڱ� �ڽŰ� �������� mean
    end
end

%31�� ä��, 7��(Sub5) ������ train
for c = 7%7��(Sub5) train�Ǵ� ������
 for e = [5:7,10,13,15,17:19]%5,6,7,10,13,15,17,18,19��(sub3,4,5,8,11,13,15,16,17) test �Ǵ� ������
  for test = [1:7,9:40]%8trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:7,9:40]%8trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 7%7��(Sub5) train�Ǵ� ������
 for e = 3%3��(sub1) test �Ǵ� ������
  for test = [1,3:7,9:39]%2,8,40trial ���� 37�� test �Ǵ� �������� trial
    for train = [1,3:7,9:39]%2,8,40trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 7%7��(Sub5) train�Ǵ� ������
 for e = 4 %4��(sub2) test �Ǵ� ������
  for test = [1:7,9:18,20:33,35,37:40]%8,19,34,36trial ���� 36�� test �Ǵ� �������� trial
    for train = [1:7,9:18,20:33,35,37:40]%8,19,34,36trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 7%7��(Sub5) train�Ǵ� ������
 for e = 9 %9��(sub7) test �Ǵ� ������
  for test = [2:7,9:40]%1,8trial ���� 38�� test �Ǵ� �������� trial
    for train =[2:7,9:40]%1,8trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end
     
for c = 7%7��(Sub5) train�Ǵ� ������
 for e = 11 %11��(sub9) test �Ǵ� ������
  for test = [1:7,9:10,12:40]%8,11trial ���� 38�� test �Ǵ� �������� trial
    for train = [1:7,9:10,12:40]%8,11trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 7%7��(Sub5) train�Ǵ� ������
 for e = 12 %12��(sub10) test �Ǵ� ������
  for test = [1:7,9:14,16:30,32:40]%8,15,31trial ���� 37�� test �Ǵ� �������� trial
    for train = [1:7,9:14,16:30,32:40]%8,15,31trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 7%7��(Sub5) train�Ǵ� ������
 for e = 14 %14��(sub12) test �Ǵ� ������
  for test = [1:7,9:34,36:40]%8,35trial ���� 38�� test �Ǵ� �������� trial
    for train = [1:7,9:34,36:40]%8,35trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=7%7��(sub5) ������
    for test=[1:7,9:40]
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/38;% �ڱ� �ڽŰ� �������� mean
    end
end

%31�� ä��, 9��(Sub7) ������ train
for c = 9%9��(sub7) train�Ǵ� ������
 for e = [5:6,9:10,13,15,17:19]%5,6,9,10,13,15,17,18,19��(sub3,4,7,8,11,13,15,16,17) test �Ǵ� ������
  for test = 2:40%1trial ���� 39�� test �Ǵ� �������� trial
    for train= 2:40%1trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 9%9��(sub7) train�Ǵ� ������
 for e = 3%3��(sub1) test �Ǵ� ������
  for test = 3:39%1,2,40trial ���� 37�� test �Ǵ� �������� trial
    for train = 3:39%1,2,40trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 9%9��(sub7) train�Ǵ� ������
 for e = 4 %4��(sub2) test �Ǵ� ������
  for test = [2:18,20:33,35,37:40]%1,19,34,36trial ���� 36�� test �Ǵ� �������� trial
    for train = [2:18,20:33,35,37:40]%1,19,34,36trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 9%9��(sub7) train�Ǵ� ������
 for e = 7 %7��(sub5) test �Ǵ� ������
  for test = [2:7,9:40]%1,8trial ���� 38�� test �Ǵ� �������� trial
    for train =[2:7,9:40]%1,8trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end
     
for c = 9%9��(sub7) train�Ǵ� ������
 for e = 11 %11��(sub9) test �Ǵ� ������
  for test = [2:10,12:40]%1,11trial ���� 38�� test �Ǵ� �������� trial
    for train = [2:10,12:40]%1,11trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 9%9��(sub7) train�Ǵ� ������
 for e = 12 %12��(sub10) test �Ǵ� ������
  for test = [2:14,16:30,32:40]%1,15,31trial ���� 37�� test �Ǵ� �������� trial
    for train = [2:14,16:30,32:40]%1,15,31trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 9%9��(sub7) train�Ǵ� ������
 for e = 14 %14��(sub12) test �Ǵ� ������
  for test = [2:34,36:40]%1,35trial ���� 38�� test �Ǵ� �������� trial
    for train = [2:34,36:40]%1,35trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=9%9��(sub7) ������
    for test=2:40
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/38;% �ڱ� �ڽŰ� �������� mean
    end
end

%31�� ä��,11��(sub9) ������ train
for c = 11%11��(sub9) train�Ǵ� ������
 for e = [5:6,10:11,13,15,17:19]%5,6,10,11,13,15,17,18,19��(sub3,4,8,9,11,13,15,16,17) test �Ǵ� ������
  for test = [1:10,12:40]%11trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:10,12:40]%11trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 11%11��(sub9) train�Ǵ� ������
 for e = 3%3��(sub1) test �Ǵ� ������
  for test = [1,3:10,12:39]%2,11,40trial ���� 37�� test �Ǵ� �������� trial
    for train = [1,3:10,12:39]%2,11,40trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 11%11��(sub9) train�Ǵ� ������
 for e = 4 %4��(sub2) test �Ǵ� ������
  for test = [1,3:10,12:18,20:33,35,37:40]%11,19,34,36trial ���� 36�� test �Ǵ� �������� trial
    for train = [1,3:10,12:18,20:33,35,37:40]%11,19,34,36trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 11%11��(sub9) train�Ǵ� ������
 for e = 7 %7��(sub5) test �Ǵ� ������
  for test = [1:7,9:10,12:40]%8,11trial ���� 38�� test �Ǵ� �������� trial
    for train =[1:7,9:10,12:40]%8,11trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end
     
for c = 11%11��(sub9) train�Ǵ� ������
 for e = 9 %11��(sub9) test �Ǵ� ������
  for test = [2:10,12:40]%1,11trial ���� 38�� test �Ǵ� �������� trial
    for train = [2:10,12:40]%1,11trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 11%11��(sub9) train�Ǵ� ������
 for e = 12 %12��(sub10) test �Ǵ� ������
  for test = [1:10,12:14,16:30,32:40]%11,15,31trial ���� 37�� test �Ǵ� �������� trial
    for train = [1:10,12:14,16:30,32:40]%11,15,31trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 11%11��(sub9) train�Ǵ� ������
 for e = 14 %14��(sub12) test �Ǵ� ������
  for test = [1:10,12:34,36:40]%11,35trial ���� 38�� test �Ǵ� �������� trial
    for train = [1:10,12:34,36:40]%11,35trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=11%11��(sub9) ������
    for test=[1:10,12:40]
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/38;% �ڱ� �ڽŰ� �������� mean
    end
end

%31�� ä��,12��(sub10) ������ train
for c = 12%12��(sub10) train�Ǵ� ������
 for e = [5:6,10,12:13,15,17:19]%5,6,10,12,13,15,17,18,19��(sub3,4,8,10,11,13,15,16,17) test �Ǵ� ������
  for test = [1:14,16:30,32:40]%15,31trial ���� 38�� test �Ǵ� �������� trial
    for train= [1:14,16:30,32:40]%15,31trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 12%12��(sub10) train�Ǵ� ������
 for e = 3%3��(sub1) test �Ǵ� ������
  for test = [1,3:14,16:30,32:39]%2,15,31,40trial ���� 36�� test �Ǵ� �������� trial
    for train = [1,3:14,16:30,32:39]%2,15,31,40trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 12%12��(sub10) train�Ǵ� ������
 for e = 4 %4��(sub2) test �Ǵ� ������
  for test = [1:14,16:18,20:30,32:33,35,37:40]%15,19,31,34,36trial ���� 35�� test �Ǵ� �������� trial
    for train = [1:14,16:18,20:30,32:33,35,37:40]%15,19,31,34,36trial ���� 35�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 12%12��(sub10) train�Ǵ� ������
 for e = 7 %7��(sub5) test �Ǵ� ������
  for test = [1:7,9:14,16:30,32:40]%8,15,31trial ���� 37�� test �Ǵ� �������� trial
    for train =[1:7,9:14,16:30,32:40]%8,15,31trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end
     
for c = 12%12��(sub10) train�Ǵ� ������
 for e = 9 %11��(sub9) test �Ǵ� ������
  for test = [2:14,16:30,32:40]%1,15,31trial ���� 37�� test �Ǵ� �������� trial
    for train = [2:14,16:30,32:40]%1,15,31trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 12%12��(sub10) train�Ǵ� ������
 for e = 11 %11��(sub9) test �Ǵ� ������
  for test = [1:10,12:14,16:30,32:40]%11,15,31trial ���� 37�� test �Ǵ� �������� trial
    for train = [1:10,12:14,16:30,32:40]%11,15,31trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 12%12��(sub10) train�Ǵ� ������
 for e = 14 %14��(sub12) test �Ǵ� ������
  for test = [1:14,16:30,32:34,36:40]%15,31,35trial ���� 37�� test �Ǵ� �������� trial
    for train = [1:14,16:30,32:34,36:40]%15,31,35trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=12%12��(sub10) ������
    for test=[1:14,16:30,32:40]
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/37;% �ڱ� �ڽŰ� �������� mean
    end
end

%31�� ä��,14��(sub12) ������ train
for c = 14%14��(sub12) train�Ǵ� ������
 for e = [5:6,10,13:15,17:19]%5,6,10,13,14,15,17,18,19��(sub3,4,8,11,12,13,15,16,17) test �Ǵ� ������
  for test = [1:34,36:40]%35trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:34,36:40]%35trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 14%14��(sub12) train�Ǵ� ������
 for e = 3%3��(sub1) test �Ǵ� ������
  for test = [1,3:34,36:39]%2,35,40trial ���� 37�� test �Ǵ� �������� trial
    for train = [1,3:34,36:39]%2,35,40trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 14%14��(sub12) train�Ǵ� ������
 for e = 4 %4��(sub2) test �Ǵ� ������
  for test = [1:18,20:33,37:40]%19,34,35,36trial ���� 36�� test �Ǵ� �������� trial
    for train = [1:18,20:33,37:40]%19,34,35,36trial ���� 36�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 14%14��(sub12) train�Ǵ� ������
 for e = 7 %7��(sub5) test �Ǵ� ������
  for test = [1:7,9:34,36:40]%8,35trial ���� 38�� test �Ǵ� �������� trial
    for train =[1:7,9:34,36:40]%8,35trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end
     
for c = 14%14��(sub12) train�Ǵ� ������
 for e = 9 %11��(sub9) test �Ǵ� ������
  for test = [2:34,36:40]%1,35trial ���� 38�� test �Ǵ� �������� trial
    for train = [2:34,36:40]%1,35trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 14%14��(sub12) train�Ǵ� ������
 for e = 11 %11��(sub9) test �Ǵ� ������
  for test = [1:10,12:34,36:40]%11,35trial ���� 38�� test �Ǵ� �������� trial
    for train = [1:10,12:34,36:40]%11,35trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 14%14��(sub12) train�Ǵ� ������
 for e = 12 %12��(sub10) test �Ǵ� ������
  for test = [1:14,16,30,32:34,36:40]%15,31,35trial ���� 37�� test �Ǵ� �������� trial
    for train = [1:14,16:30,32:34,36:40]%15,31,35trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx{e}{test}.*noOutMtx{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=14%14��(sub12) ������
    for test=[1:34,36:40]
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/38;% �ڱ� �ڽŰ� �������� mean
    end
end

%% ������ �� 29 ä�� �з�-1session(25,28ch ����), 2session(3,8ch ����) 16�� ������(sub14) ����
 for nn=[3:15,17:19] 
 for num=2*nn-1 %��� ������ 1session
   rowdata2{num} = [data{num}(:,2:25),data{num}(:,27:28),data{num}(:,30:32)];%data 1~24,26,27,29~31ch
   cardata2{num} = rowdata2{num}-repmat(mean(rowdata2{num},2), 1, 29);%CAR x���� ä��, y���� �ð�

   Wn=[1 45]; %���ļ��뿪
   [b,a]=butter(3, Wn/512, 'bandpass');%Butter 
   Y2{num} = filter(b,a, cardata2{num});%filtering
 end

  for num=2*nn %8��������(sub6) 2session
   rowdata2{num} = [data{num}(:,2:3),data{num}(:,5:8),data{num}(:,10:32)];%data 1~2,4~7,9~31ch 
   cardata2{num} = rowdata2{num}-repmat(mean(rowdata2{num},2), 1, 29);%CAR x���� ä��, y���� �ð�
    
   Wn=[1 45]; %���ļ��뿪
   [b,a]=butter(3, Wn/512, 'bandpass');%Butter 
   Y2{num} = filter(b,a, cardata2{num});%filtering
  end
 end
  
 %% �����ں� trial �з� 29ch
  for n=5 % 3�� ������(sub1) 1session 
  for trial5 = [1,3:20]% 2�� trial������ �� 19�� trial
 
     
       op2{n}= Y2{n}(((trial5-1)*30.5+21-eo)*512:((trial5-1)*30.5+21)*512,:);
       cl2{n}= Y2{n}(((trial5-1)*30.5+21)*512:((trial5-1)*30.5+21+ec)*512,:);
         
        for chIdx2 = 1:29
           [so2{n}, fo2{n}, to2{n}, po2{n}(:,:,chIdx2)] = spectrogram(op2{n}(:,chIdx2),window,overlap,N,fs);%spectrogramǥ��
           [sc2{n}, fc2{n}, tc2{n}, pc2{n}(:,:,chIdx2)] = spectrogram(cl2{n}(:,chIdx2),window,overlap,N,fs);
        end
         mean_po2{n}=mean(po2{n},2);%�� trial ���� ���
         mean_pc2{n}=mean(pc2{n},2);
         
         diff2{n}=mean_pc2{n} - mean_po2{n};%��հ� close-open ����
         diff_reall2{n}{trial5}=abs(diff2{n}(7:16,:));%6~15hz ���� ���캽-0hz�� �ش��ϴ� �͵� �����������(fo or fc�� Ȯ��)
  end
 end
 
 for n=6 % 3�� ������(sub1) 2session 
  for trial6 = 1:19% 20�� trial������ �� 19�� trial
    
       op2{n}= Y2{n}(((trial6-1)*30.5+21-eo)*512:((trial6-1)*30.5+21)*512,:);
       cl2{n}= Y2{n}(((trial6-1)*30.5+21)*512:((trial6-1)*30.5+21+ec)*512,:);
         
        for chIdx2 = 1:29
           [so2{n}, fo2{n}, to2{n}, po2{n}(:,:,chIdx2)] = spectrogram(op2{n}(:,chIdx2),window,overlap,N,fs);%spectrogramǥ��
           [sc2{n}, fc2{n}, tc2{n}, pc2{n}(:,:,chIdx2)] = spectrogram(cl2{n}(:,chIdx2),window,overlap,N,fs);
        end
         mean_po2{n}=mean(po2{n},2);%�� trial ���� ���
         mean_pc2{n}=mean(pc2{n},2);
         
         diff2{n}=mean_pc2{n} - mean_po2{n};%��հ� close-open ����
         diff_reall2{n}{trial6}=abs(diff2{n}(7:16,:));%6~15hz ���� ���캽-0hz�� �ش��ϴ� �͵� �����������(fo or fc�� Ȯ��)
  end
 end
 
  for num=[9:12,14,18:20,22,25:27,29:30,33:38] %5,6,10,13,15,17,18,19��(sub3,4,8,11,13,15,16,17) ������ 1~2 session
                                               %7(sub5),9(sub7),11(sub9)-->2session
                                               %14(sub12)-->1session
     for trial = 1:20%20trial
     
       op2{num}=Y2{num}(((trial-1)*31+21-eo)*512:((trial-1)*31+21)*512,:);
       cl2{num}=Y2{num}(((trial-1)*31+21.5)*512:((trial-1)*31+21.5+ec)*512,:);
  
        for chIdx2 = 1:29
           [so2{num}, fo2{num}, to2{num}, po2{num}(:,:,chIdx2)] = spectrogram(op2{num}(:,chIdx2),window,overlap,N,fs);
           [sc2{num}, fc2{num}, tc2{num}, pc2{num}(:,:,chIdx2)] = spectrogram(cl2{num}(:,chIdx2),window,overlap,N,fs);
        end
  
           mean_po2{num}=mean(po2{num},2);
           mean_pc2{num}=mean(pc2{num},2);
    
           diff2{num}=mean_pc2{num} - mean_po2{num}; %��հ� close-open ����
           diff_reall2{num}{trial}=abs(diff2{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
      end
  end
 
 for num=7 %4��(sub2) ������ 1session
     for trial7 = [1:18,20]%19trial �����ϰ� �� 19�� trial
     
    
       op2{num}=Y2{num}(((trial7-1)*31+21-eo)*512:((trial7-1)*31+21)*512,:);
       cl2{num}=Y2{num}(((trial7-1)*31+21.5)*512:((trial7-1)*31+21.5+ec)*512,:);
  
        for chIdx2 = 1:29
           [so2{num}, fo2{num}, to2{num}, po2{num}(:,:,chIdx2)] = spectrogram(op2{num}(:,chIdx2),window,overlap,N,fs);
           [sc2{num}, fc2{num}, tc2{num}, pc2{num}(:,:,chIdx2)] = spectrogram(cl2{num}(:,chIdx2),window,overlap,N,fs);
        end
  
           mean_po2{num}=mean(po2{num},2);
           mean_pc2{num}=mean(pc2{num},2);
    
           diff2{num}=mean_pc2{num} - mean_po2{num}; %��հ� close-open ����
           diff_reall2{num}{trial7}=abs(diff2{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
 end
 
 for num=8 %4��(sub2) ������ 2session
     for trial8 = [1:13,15,17:20]%14,16�� trial ���� �� 18 trial
   
    
       op2{num}=Y2{num}(((trial8-1)*31+21-eo)*512:((trial8-1)*31+21)*512,:);
       cl2{num}=Y2{num}(((trial8-1)*31+21.5)*512:((trial8-1)*31+21.5+ec)*512,:);
  
        for chIdx2 = 1:29
           [so2{num}, fo2{num}, to2{num}, po2{num}(:,:,chIdx2)] = spectrogram(op2{num}(:,chIdx2),window,overlap,N,fs);
           [sc2{num}, fc2{num}, tc2{num}, pc2{num}(:,:,chIdx2)] = spectrogram(cl2{num}(:,chIdx2),window,overlap,N,fs);
        end
  
           mean_po2{num}=mean(po2{num},2);
           mean_pc2{num}=mean(pc2{num},2);
    
           diff2{num}=mean_pc2{num} - mean_po2{num}; %��հ� close-open ����
           diff_reall2{num}{trial8}=abs(diff2{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
 end
 
  for num=13 %7��(sub5) ������ 1session
     for trial13 = [1:7,9:20]%8�� terial ���� �� 19 trial
   
    
       op2{num}=Y2{num}(((trial13-1)*31+21-eo)*512:((trial13-1)*31+21)*512,:);
       cl2{num}=Y2{num}(((trial13-1)*31+21.5)*512:((trial13-1)*31+21.5+ec)*512,:);
  
        for chIdx2 = 1:29
           [so2{num}, fo2{num}, to2{num}, po2{num}(:,:,chIdx2)] = spectrogram(op2{num}(:,chIdx2),window,overlap,N,fs);
           [sc2{num}, fc2{num}, tc2{num}, pc2{num}(:,:,chIdx2)] = spectrogram(cl2{num}(:,chIdx2),window,overlap,N,fs);
        end
  
           mean_po2{num}=mean(po2{num},2);
           mean_pc2{num}=mean(pc2{num},2);
    
           diff2{num}=mean_pc2{num} - mean_po2{num}; %��հ� close-open ����
           diff_reall2{num}{trial13}=abs(diff2{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
 
   for num=15:16%8��(sub6) ������ 1session
     for trial15 = 1:20%20 trial
    
       op2{num}=Y2{num}(((trial15-1)*31+21-eo)*512:((trial15-1)*31+21)*512,:);
       cl2{num}=Y2{num}(((trial15-1)*31+21.5)*512:((trial15-1)*31+21.5+ec)*512,:);

        for chIdx2 = 1:29 % 29�� ä�� 
           [so2{num}, fo2{num}, to2{num}, po2{num}(:,:,chIdx2)] = spectrogram(op2{num}(:,chIdx2),window,overlap,N,fs);
           [sc2{num}, fc2{num}, tc2{num}, pc2{num}(:,:,chIdx2)] = spectrogram(cl2{num}(:,chIdx2),window,overlap,N,fs);
        end
    
           mean_po2{num}=mean(po2{num},2);
           mean_pc2{num}=mean(pc2{num},2);
    
           diff2{num}=mean_pc2{num} - mean_po2{num}; %��հ� close-open ����
           diff_reall2{num}{trial15}=abs(diff2{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
   end
  
   for num=17 %9��(sub7) ������ 1session
     for trial17 = 2:20%1�� trial ���� �� 19 trial
         
       op2{num}=Y2{num}(((trial17-1)*31+21-eo)*512:((trial17-1)*31+21)*512,:);
       cl2{num}=Y2{num}(((trial17-1)*31+21.5)*512:((trial17-1)*31+21.5+ec)*512,:);
  
        for chIdx2 = 1:29
           [so2{num}, fo2{num}, to2{num}, po2{num}(:,:,chIdx2)] = spectrogram(op2{num}(:,chIdx2),window,overlap,N,fs);
           [sc2{num}, fc2{num}, tc2{num}, pc2{num}(:,:,chIdx2)] = spectrogram(cl2{num}(:,chIdx2),window,overlap,N,fs);
        end
  
           mean_po2{num}=mean(po2{num},2);
           mean_pc2{num}=mean(pc2{num},2);
    
           diff2{num}=mean_pc2{num} - mean_po2{num}; %��հ� close-open ����
           diff_reall2{num}{trial17}=abs(diff2{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
   
  for num=[21,24] %11��(sub9) ������ 1session, 12��(sub10) ������ 2session
     for trial21 = [1:10,12:20]%11�� trial ���� �� 19 trial
  
    
       op2{num}=Y2{num}(((trial21-1)*31+21-eo)*512:((trial21-1)*31+21)*512,:);
       cl2{num}=Y2{num}(((trial21-1)*31+21.5)*512:((trial21-1)*31+21.5+ec)*512,:);
  
        for chIdx2 = 1:29
           [so2{num}, fo2{num}, to2{num}, po2{num}(:,:,chIdx2)] = spectrogram(op2{num}(:,chIdx2),window,overlap,N,fs);
           [sc2{num}, fc2{num}, tc2{num}, pc2{num}(:,:,chIdx2)] = spectrogram(cl2{num}(:,chIdx2),window,overlap,N,fs);
        end
  
           mean_po2{num}=mean(po2{num},2);
           mean_pc2{num}=mean(pc2{num},2);
    
           diff2{num}=mean_pc2{num} - mean_po2{num}; %��հ� close-open ����
           diff_reall2{num}{trial21}=abs(diff2{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
  
  for num=[23,28] %12��(sub10) ������ 1session, 14��(sub12) ������ 2session
     for trial23 = [1:14,16:20]%15�� trial ���� �� 19 trial
   
    
       op2{num}=Y2{num}(((trial23-1)*31+21-eo)*512:((trial23-1)*31+21)*512,:);
       cl2{num}=Y2{num}(((trial23-1)*31+21.5)*512:((trial23-1)*31+21.5+ec)*512,:);
  
        for chIdx2 = 1:29
           [so2{num}, fo2{num}, to2{num}, po2{num}(:,:,chIdx2)] = spectrogram(op2{num}(:,chIdx2),window,overlap,N,fs);
           [sc2{num}, fc2{num}, tc2{num}, pc2{num}(:,:,chIdx2)] = spectrogram(cl2{num}(:,chIdx2),window,overlap,N,fs);
        end
  
           mean_po2{num}=mean(po2{num},2);
           mean_pc2{num}=mean(pc2{num},2);
    
           diff2{num}=mean_pc2{num} - mean_po2{num}; %��հ� close-open ����
           diff_reall2{num}{trial23}=abs(diff2{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
  
   for ii= 3:19%2session ��ġ��
     diff_real2{ii}=([diff_reall2{2*ii-1},diff_reall2{2*ii}]);
   end
   %% outlier
 for ii=3
         for iii=[1,3:39]
         xx2{ii}{iii}=reshape(diff_real2{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q12{ii}{iii} = quantile(xx2{ii}{iii}, 0.25);
         q32{ii}{iii} = quantile(xx2{ii}{iii}, 0.75);
         iqr2{ii}{iii} = q32{ii}{iii} - q12{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len2 = 1:length(xx2{ii}{iii})
    if (xx2{ii}{iii}(len2) > q32{ii}{iii}+(iqr2{ii}{iii}*3)) || (xx2{ii}{iii}(len2) < q12{ii}{iii}-(iqr2{ii}{iii}*3))
        xx2{ii}{iii}(len2) = 0;
    end
         end

    noOutMtx2{ii}{iii} = reshape(xx2{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
     end
     
      for ii=4
         for iii=[1:18,20:33,35,37:40]
         xx2{ii}{iii}=reshape(diff_real2{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q12{ii}{iii} = quantile(xx2{ii}{iii}, 0.25);
         q32{ii}{iii} = quantile(xx2{ii}{iii}, 0.75);
         iqr2{ii}{iii} = q32{ii}{iii} - q12{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len2 = 1:length(xx2{ii}{iii})
    if (xx2{ii}{iii}(len2) > q32{ii}{iii}+(iqr2{ii}{iii}*3)) || (xx2{ii}{iii}(len2) < q12{ii}{iii}-(iqr2{ii}{iii}*3))
        xx2{ii}{iii}(len2) = 0;
    end
         end

    noOutMtx2{ii}{iii} = reshape(xx2{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
          end
     
       for ii=[5:6,8,10,13,15,17:19]
         for iii=1:40
         xx2{ii}{iii}=reshape(diff_real2{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q12{ii}{iii} = quantile(xx2{ii}{iii}, 0.25);
         q32{ii}{iii} = quantile(xx2{ii}{iii}, 0.75);
         iqr2{ii}{iii} = q32{ii}{iii} - q12{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len2 = 1:length(xx2{ii}{iii})
    if (xx2{ii}{iii}(len2) > q32{ii}{iii}+(iqr2{ii}{iii}*3)) || (xx2{ii}{iii}(len2) < q12{ii}{iii}-(iqr2{ii}{iii}*3))
        xx2{ii}{iii}(len2) = 0;
    end
         end

    noOutMtx2{ii}{iii} = reshape(xx2{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
       end
     
     for ii=7
         for iii=[1:7,9:40]
         xx2{ii}{iii}=reshape(diff_real2{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q12{ii}{iii} = quantile(xx2{ii}{iii}, 0.25);
         q32{ii}{iii} = quantile(xx2{ii}{iii}, 0.75);
         iqr2{ii}{iii} = q32{ii}{iii} - q12{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len2 = 1:length(xx2{ii}{iii})
    if (xx2{ii}{iii}(len2) > q32{ii}{iii}+(iqr2{ii}{iii}*3)) || (xx2{ii}{iii}(len2) < q12{ii}{iii}-(iqr2{ii}{iii}*3))
        xx2{ii}{iii}(len2) = 0;
    end
         end

    noOutMtx2{ii}{iii} = reshape(xx2{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
     end
     
     for ii=9
         for iii=2:40
         xx2{ii}{iii}=reshape(diff_real2{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q12{ii}{iii} = quantile(xx2{ii}{iii}, 0.25);
         q32{ii}{iii} = quantile(xx2{ii}{iii}, 0.75);
         iqr2{ii}{iii} = q32{ii}{iii} - q12{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len2 = 1:length(xx2{ii}{iii})
    if (xx2{ii}{iii}(len2) > q32{ii}{iii}+(iqr2{ii}{iii}*3)) || (xx2{ii}{iii}(len2) < q12{ii}{iii}-(iqr2{ii}{iii}*3))
        xx2{ii}{iii}(len2) = 0;
    end
         end

    noOutMtx2{ii}{iii} = reshape(xx2{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
     end
     
      for ii=11
         for iii=[1:10,12:40]
         xx2{ii}{iii}=reshape(diff_real2{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q12{ii}{iii} = quantile(xx2{ii}{iii}, 0.25);
         q32{ii}{iii} = quantile(xx2{ii}{iii}, 0.75);
         iqr2{ii}{iii} = q32{ii}{iii} - q12{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len2 = 1:length(xx2{ii}{iii})
    if (xx2{ii}{iii}(len2) > q32{ii}{iii}+(iqr2{ii}{iii}*3)) || (xx2{ii}{iii}(len2) < q12{ii}{iii}-(iqr2{ii}{iii}*3))
        xx2{ii}{iii}(len2) = 0;
    end
         end

    noOutMtx2{ii}{iii} = reshape(xx2{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
      end
     
      for ii=12
         for iii=[1:14,16:30,32:40]
         xx2{ii}{iii}=reshape(diff_real2{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q12{ii}{iii} = quantile(xx2{ii}{iii}, 0.25);
         q32{ii}{iii} = quantile(xx2{ii}{iii}, 0.75);
         iqr2{ii}{iii} = q32{ii}{iii} - q12{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len2 = 1:length(xx2{ii}{iii})
    if (xx2{ii}{iii}(len2) > q32{ii}{iii}+(iqr2{ii}{iii}*3)) || (xx2{ii}{iii}(len2) < q12{ii}{iii}-(iqr2{ii}{iii}*3))
        xx2{ii}{iii}(len2) = 0;
    end
         end

    noOutMtx2{ii}{iii} = reshape(xx2{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
      end
     
       for ii=14
         for iii=[1:34,36:40]
         xx2{ii}{iii}=reshape(diff_real2{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q12{ii}{iii} = quantile(xx2{ii}{iii}, 0.25);
         q32{ii}{iii} = quantile(xx2{ii}{iii}, 0.75);
         iqr2{ii}{iii} = q32{ii}{iii} - q12{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len2 = 1:length(xx2{ii}{iii})
    if (xx2{ii}{iii}(len2) > q32{ii}{iii}+(iqr2{ii}{iii}*3)) || (xx2{ii}{iii}(len2) < q12{ii}{iii}-(iqr2{ii}{iii}*3))
        xx2{ii}{iii}(len2) = 0;
    end
         end

    noOutMtx2{ii}{iii} = reshape(xx2{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
       end
 %% CC-8�� ������ 29 ch -16�� ������ ����
     %29�� ä�ΰ� 8�� ������ train
for c = [5:6,8,10,13,15,17:19]%5,6,8,10,13,15,17,18,19��(sub3,4,6,8,11,13,15,16,17) train�Ǵ� ������
 for e = 8%8��(sub6) test �Ǵ� ������
  for test = 1:40%test �Ǵ� �������� trial
    for train=1:40%train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 3%3��(sub1) train�Ǵ� ������
 for e = 8%8��(sub6) test �Ǵ� ������
  for test = [1,3:39]%2,40 trial ���� 38�� test �Ǵ� �������� trial
    for train=[1,3:39]%2,40 trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 4%4��(sub2) train�Ǵ� ������
 for e = 8%8��(sub6) test �Ǵ� ������
  for test = [1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� test �Ǵ� �������� trial
    for train=[1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 7%7��(sub5) train�Ǵ� ������
 for e = 8%8��(sub6) test �Ǵ� ������
  for test = [1:7,9:40]%8 trial ���� 39�� test �Ǵ� �������� trial
    for train=[1:7,9:40]%8 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 9%9��(sub7) train�Ǵ� ������
 for e = 8%8��(sub6) test �Ǵ� ������
  for test = 2:40%1 trial ���� 39�� test �Ǵ� �������� trial
    for train= 2:40%1  trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 11%11��(sub9) train�Ǵ� ������
 for e = 8%8��(sub6) test �Ǵ� ������
  for test = [1:10,12:40]%11 trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:10,12:40]%11 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 12%12��(sub10) train�Ǵ� ������
 for e = 8%8��(sub6) test �Ǵ� ������
  for test = [1:14,16:30,32:40]%15,31 trial ���� 38�� test �Ǵ� �������� trial
    for train= [1:14,16:30,32:40]%15,31 trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 14%14��(sub12) train�Ǵ� ������
 for e = 8%8��(sub6) test �Ǵ� ������
  for test = [1:34,36:40]%35 trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:34,36:40]%35 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

%8�������� train
for c = 8%8��(sub6) train�Ǵ� ������
 for e = [5:6,8,10,13,15,17:19]%5,6,8,10,13,15,17,18,19��(sub3,4,6,8,11,13,15,16,17) test �Ǵ� ������
  for test = 1:40%test �Ǵ� �������� trial
    for train=1:40%train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 8%8��(sub6) train�Ǵ� ������
 for e = 3%8��(sub1) test �Ǵ� ������
  for test = [1,3:39]%2,40 trial ���� 38�� test �Ǵ� �������� trial
    for train=[1,3:39]%2,40 trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 8%8��(sub6) train�Ǵ� ������
 for e = 4%4��(sub2) test �Ǵ� ������
  for test = [1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� test �Ǵ� �������� trial
    for train=[1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 8%8��(sub6) train�Ǵ� ������
 for e = 7%7��(sub5) test �Ǵ� ������
  for test = [1:7,9:40]%8 trial ���� 39�� test �Ǵ� �������� trial
    for train=[1:7,9:40]%8 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 8%8��(sub6) train�Ǵ� ������
 for e = 9%9��(sub7) test �Ǵ� ������
  for test = 2:40%1 trial ���� 39�� test �Ǵ� �������� trial
    for train= 2:40%1  trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 8%8��(sub6) train�Ǵ� ������
 for e = 11%11��(sub9) test �Ǵ� ������
  for test = [1:10,12:40]%11 trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:10,12:40]%11 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 8%8��(sub6) train�Ǵ� ������
 for e = 12%12��(sub10) test �Ǵ� ������
  for test = [1:14,16:30,32:40]%15,31 trial ���� 38�� test �Ǵ� �������� trial
    for train= [1:14,16:30,32:40]%15,31 trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 8%8��(sub6) train�Ǵ� ������
 for e = 14%14��(sub12) test �Ǵ� ������
  for test = [1:34,36:40]%35 trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:34,36:40]%35 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx2{e}{test}.*noOutMtx2{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx2{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx2{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=8%8��(sub6) ������
    for test=1:40
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/39;% �ڱ� �ڽŰ� �������� mean
    end
end       
%% ������ �� 29 ä�� �з�-1~2session(10,11ch) 8�� ������(sub6) ����
 for num=[5:14,17:38]%8��������(sub6) 1,2session ������ ��� ������
   rowdata3{num} = [data{num}(:,2:10),data{num}(:,13:32)];%data 1~9,12~31ch 
   cardata3{num} = rowdata3{num}-repmat(mean(rowdata3{num},2), 1, 29);%CAR x���� ä��, y���� �ð�
    
   Wn=[1 45]; %���ļ��뿪
   [b,a]=butter(3, Wn/512, 'bandpass');%Butter 
   Y3{num} = filter(b,a, cardata3{num});%filtering
 end
  %% �����ں� trial �з�-8�������� ����
  for n=5 % 3�� ������(sub1) 1session 
  for trial5 = [1,3:20]% 2�� trial������ �� 19�� trial
      
       op3{n}= Y3{n}(((trial5-1)*30.5+21-eo)*512:((trial5-1)*30.5+21)*512,:);
       cl3{n}= Y3{n}(((trial5-1)*30.5+21)*512:((trial5-1)*30.5+21+ec)*512,:);
         
        for chIdx3 = 1:29
           [so3{n}, fo3{n}, to3{n}, po3{n}(:,:,chIdx3)] = spectrogram(op3{n}(:,chIdx3),window,overlap,N,fs);%spectrogramǥ��
           [sc3{n}, fc3{n}, tc3{n}, pc3{n}(:,:,chIdx3)] = spectrogram(cl3{n}(:,chIdx3),window,overlap,N,fs);
        end
         mean_po3{n}=mean(po3{n},2);%�� trial ���� ���
         mean_pc3{n}=mean(pc3{n},2);
         
         diff3{n}=mean_pc3{n} - mean_po3{n};%��հ� close-open ����
         diff_reall3{n}{trial5}=abs(diff3{n}(7:16,:));%6~15hz ���� ���캽-0hz�� �ش��ϴ� �͵� �����������(fo or fc�� Ȯ��)
  end
 end
 
 for n=6 % 3�� ������(sub1) 2session 
  for trial6 = 1:19% 20�� trial������ �� 19�� trial
     
     
       op3{n}= Y3{n}(((trial6-1)*30.5+21-eo)*512:((trial6-1)*30.5+21)*512,:);
       cl3{n}= Y3{n}(((trial6-1)*30.5+21)*512:((trial6-1)*30.5+21+ec)*512,:);
         
        for chIdx3 = 1:29
           [so3{n}, fo3{n}, to3{n}, po3{n}(:,:,chIdx3)] = spectrogram(op3{n}(:,chIdx3),window,overlap,N,fs);%spectrogramǥ��
           [sc3{n}, fc3{n}, tc3{n}, pc3{n}(:,:,chIdx3)] = spectrogram(cl3{n}(:,chIdx3),window,overlap,N,fs);
        end
         mean_po3{n}=mean(po3{n},2);%�� trial ���� ���
         mean_pc3{n}=mean(pc3{n},2);
         
         diff3{n}=mean_pc3{n} - mean_po3{n};%��հ� close-open ����
         diff_reall3{n}{trial6}=abs(diff3{n}(7:16,:));%6~15hz ���� ���캽-0hz�� �ش��ϴ� �͵� �����������(fo or fc�� Ȯ��)
  end
 end
 
  for num=[9:12,14,18:20,22,25:27,29:38] %5,6,10,13,15,16,17,18,19��(sub3,4,8,11,13,14,15,16,17) ������ 1~2 session
                                               %7(sub5),9(sub7),11(sub9)-->2session
                                               %14(sub12)-->1session
     for trial = 1:20%20trial
     
       op3{num}=Y3{num}(((trial-1)*31+21-eo)*512:((trial-1)*31+21)*512,:);
       cl3{num}=Y3{num}(((trial-1)*31+21.5)*512:((trial-1)*31+21.5+ec)*512,:);
  
        for chIdx3 = 1:29
           [so3{num}, fo3{num}, to3{num}, po3{num}(:,:,chIdx3)] = spectrogram(op3{num}(:,chIdx3),window,overlap,N,fs);
           [sc3{num}, fc3{num}, tc3{num}, pc3{num}(:,:,chIdx3)] = spectrogram(cl3{num}(:,chIdx3),window,overlap,N,fs);
        end
  
           mean_po3{num}=mean(po3{num},2);
           mean_pc3{num}=mean(pc3{num},2);
    
           diff3{num}=mean_pc3{num} - mean_po3{num}; %��հ� close-open ����
           diff_reall3{num}{trial}=abs(diff3{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
      end
  end
 
 for num=7 %4��(sub2) ������ 1session
     for trial7 = [1:18,20]%19trial �����ϰ� �� 19�� trial
   
    
       op3{num}=Y3{num}(((trial7-1)*31+21-eo)*512:((trial7-1)*31+21)*512,:);
       cl3{num}=Y3{num}(((trial7-1)*31+21.5)*512:((trial7-1)*31+21.5+ec)*512,:);
  
        for chIdx3 = 1:29
           [so3{num}, fo3{num}, to3{num}, po3{num}(:,:,chIdx3)] = spectrogram(op3{num}(:,chIdx3),window,overlap,N,fs);
           [sc3{num}, fc3{num}, tc3{num}, pc3{num}(:,:,chIdx3)] = spectrogram(cl3{num}(:,chIdx3),window,overlap,N,fs);
        end
  
           mean_po3{num}=mean(po3{num},2);
           mean_pc3{num}=mean(pc3{num},2);
    
           diff3{num}=mean_pc3{num} - mean_po3{num}; %��հ� close-open ����
           diff_reall3{num}{trial7}=abs(diff3{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
 end
 
 for num=8 %4��(sub2) ������ 2session
     for trial8 = [1:13,15,17:20]%14,16�� trial ���� �� 18 trial

    
       op3{num}=Y3{num}(((trial8-1)*31+21-eo)*512:((trial8-1)*31+21)*512,:);
       cl3{num}=Y3{num}(((trial8-1)*31+21.5)*512:((trial8-1)*31+21.5+ec)*512,:);
  
        for chIdx3 = 1:29
           [so3{num}, fo3{num}, to3{num}, po3{num}(:,:,chIdx3)] = spectrogram(op3{num}(:,chIdx3),window,overlap,N,fs);
           [sc3{num}, fc3{num}, tc3{num}, pc3{num}(:,:,chIdx3)] = spectrogram(cl3{num}(:,chIdx3),window,overlap,N,fs);
        end
  
           mean_po3{num}=mean(po3{num},2);
           mean_pc3{num}=mean(pc3{num},2);
    
           diff3{num}=mean_pc3{num} - mean_po3{num}; %��հ� close-open ����
           diff_reall3{num}{trial8}=abs(diff3{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
 end
 
  for num=13 %7��(sub5) ������ 1session
     for trial13 = [1:7,9:20]%8�� terial ���� �� 19 trial
   
       op3{num}=Y3{num}(((trial13-1)*31+21-eo)*512:((trial13-1)*31+21)*512,:);
       cl3{num}=Y3{num}(((trial13-1)*31+21.5)*512:((trial13-1)*31+21.5+ec)*512,:);
  
        for chIdx3 = 1:29
           [so3{num}, fo3{num}, to3{num}, po3{num}(:,:,chIdx3)] = spectrogram(op3{num}(:,chIdx3),window,overlap,N,fs);
           [sc3{num}, fc3{num}, tc3{num}, pc3{num}(:,:,chIdx3)] = spectrogram(cl3{num}(:,chIdx3),window,overlap,N,fs);
        end
  
           mean_po3{num}=mean(po3{num},2);
           mean_pc3{num}=mean(pc3{num},2);
    
           diff3{num}=mean_pc3{num} - mean_po3{num}; %��հ� close-open ����
           diff_reall3{num}{trial13}=abs(diff3{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
  
   for num=17 %9��(sub7) ������ 1session
     for trial17 = 2:20%1�� trial ���� �� 19 trial
   
       op3{num}=Y3{num}(((trial17-1)*31+21-eo)*512:((trial17-1)*31+21)*512,:);
       cl3{num}=Y3{num}(((trial17-1)*31+21.5)*512:((trial17-1)*31+21.5+ec)*512,:);
  
        for chIdx3 = 1:29
           [so3{num}, fo3{num}, to3{num}, po3{num}(:,:,chIdx3)] = spectrogram(op3{num}(:,chIdx3),window,overlap,N,fs);
           [sc3{num}, fc3{num}, tc3{num}, pc3{num}(:,:,chIdx3)] = spectrogram(cl3{num}(:,chIdx3),window,overlap,N,fs);
        end
  
           mean_po3{num}=mean(po3{num},2);
           mean_pc3{num}=mean(pc3{num},2);
    
           diff3{num}=mean_pc3{num} - mean_po3{num}; %��հ� close-open ����
           diff_reall3{num}{trial17}=abs(diff3{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
   
  for num=[21,24] %11��(sub9) ������ 1session, 12��(sub10) ������ 2session
     for trial21 = [1:10,12:20]%11�� trial ���� �� 19 trial

    
       op3{num}=Y3{num}(((trial21-1)*31+21-eo)*512:((trial21-1)*31+21)*512,:);
       cl3{num}=Y3{num}(((trial21-1)*31+21.5)*512:((trial21-1)*31+21.5+ec)*512,:);
  
        for chIdx3 = 1:29
           [so3{num}, fo3{num}, to3{num}, po3{num}(:,:,chIdx3)] = spectrogram(op3{num}(:,chIdx3),window,overlap,N,fs);
           [sc3{num}, fc3{num}, tc3{num}, pc3{num}(:,:,chIdx3)] = spectrogram(cl3{num}(:,chIdx3),window,overlap,N,fs);
        end
  
           mean_po3{num}=mean(po3{num},2);
           mean_pc3{num}=mean(pc3{num},2);
    
           diff3{num}=mean_pc3{num} - mean_po3{num}; %��հ� close-open ����
           diff_reall3{num}{trial21}=abs(diff3{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
  
  for num=[23,28] %12��(sub10) ������ 1session, 14��(sub12) ������ 2session
     for trial23 = [1:14,16:20]%15�� trial ���� �� 19 trial

    
       op3{num}=Y3{num}(((trial23-1)*31+21-eo)*512:((trial23-1)*31+21)*512,:);
       cl3{num}=Y3{num}(((trial23-1)*31+21.5)*512:((trial23-1)*31+21.5+ec)*512,:);
  
        for chIdx3 = 1:29
           [so3{num}, fo3{num}, to3{num}, po3{num}(:,:,chIdx3)] = spectrogram(op3{num}(:,chIdx3),window,overlap,N,fs);
           [sc3{num}, fc3{num}, tc3{num}, pc3{num}(:,:,chIdx3)] = spectrogram(cl3{num}(:,chIdx3),window,overlap,N,fs);
        end
  
           mean_po3{num}=mean(po3{num},2);
           mean_pc3{num}=mean(pc3{num},2);
    
           diff3{num}=mean_pc3{num} - mean_po3{num}; %��հ� close-open ����
           diff_reall3{num}{trial23}=abs(diff3{num}(7:16,:)); %6~15hz ���� ���캽-0hz�� �ش��ϴ� �� ����
     end
  end
  
   for ii= [3:7,9:19]%2session ��ġ��
     diff_real3{ii}=([diff_reall3{2*ii-1},diff_reall3{2*ii}]);
   end
   %% outlier
    for ii=3
         for iii=[1,3:39]
         xx3{ii}{iii}=reshape(diff_real3{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q13{ii}{iii} = quantile(xx3{ii}{iii}, 0.25);
         q33{ii}{iii} = quantile(xx3{ii}{iii}, 0.75);
         iqr3{ii}{iii} = q33{ii}{iii} - q13{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len3 = 1:length(xx3{ii}{iii})
    if (xx3{ii}{iii}(len3) > q33{ii}{iii}+(iqr3{ii}{iii}*3)) || (xx3{ii}{iii}(len3) < q13{ii}{iii}-(iqr3{ii}{iii}*3))
        xx3{ii}{iii}(len3) = 0;
    end
         end

    noOutMtx3{ii}{iii} = reshape(xx3{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
     end
     
      for ii=4
         for iii=[1:18,20:33,35,37:40]
         xx3{ii}{iii}=reshape(diff_real3{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q13{ii}{iii} = quantile(xx3{ii}{iii}, 0.25);
         q33{ii}{iii} = quantile(xx3{ii}{iii}, 0.75);
         iqr3{ii}{iii} = q33{ii}{iii} - q13{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len3 = 1:length(xx3{ii}{iii})
    if (xx3{ii}{iii}(len3) > q33{ii}{iii}+(iqr3{ii}{iii}*3)) || (xx3{ii}{iii}(len3) < q13{ii}{iii}-(iqr3{ii}{iii}*3))
        xx3{ii}{iii}(len3) = 0;
    end
         end

    noOutMtx3{ii}{iii} = reshape(xx3{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
          end
     
       for ii=[5:6,10,13,15:19]
         for iii=1:40
         xx3{ii}{iii}=reshape(diff_real3{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q13{ii}{iii} = quantile(xx3{ii}{iii}, 0.25);
         q33{ii}{iii} = quantile(xx3{ii}{iii}, 0.75);
         iqr3{ii}{iii} = q33{ii}{iii} - q13{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len3 = 1:length(xx3{ii}{iii})
    if (xx3{ii}{iii}(len3) > q33{ii}{iii}+(iqr3{ii}{iii}*3)) || (xx3{ii}{iii}(len3) < q13{ii}{iii}-(iqr3{ii}{iii}*3))
        xx3{ii}{iii}(len3) = 0;
    end
         end

    noOutMtx3{ii}{iii} = reshape(xx3{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
       end
     
     for ii=7
         for iii=[1:7,9:40]
         xx3{ii}{iii}=reshape(diff_real3{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q13{ii}{iii} = quantile(xx3{ii}{iii}, 0.25);
         q33{ii}{iii} = quantile(xx3{ii}{iii}, 0.75);
         iqr3{ii}{iii} = q33{ii}{iii} - q13{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len3 = 1:length(xx3{ii}{iii})
    if (xx3{ii}{iii}(len3) > q33{ii}{iii}+(iqr3{ii}{iii}*3)) || (xx3{ii}{iii}(len3) < q13{ii}{iii}-(iqr3{ii}{iii}*3))
        xx3{ii}{iii}(len3) = 0;
    end
         end

    noOutMtx3{ii}{iii} = reshape(xx3{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
     end
     
     for ii=9
         for iii=2:40
         xx3{ii}{iii}=reshape(diff_real3{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q13{ii}{iii} = quantile(xx3{ii}{iii}, 0.25);
         q33{ii}{iii} = quantile(xx3{ii}{iii}, 0.75);
         iqr3{ii}{iii} = q33{ii}{iii} - q13{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len3 = 1:length(xx3{ii}{iii})
    if (xx3{ii}{iii}(len3) > q33{ii}{iii}+(iqr3{ii}{iii}*3)) || (xx3{ii}{iii}(len3) < q13{ii}{iii}-(iqr3{ii}{iii}*3))
        xx3{ii}{iii}(len3) = 0;
    end
         end

    noOutMtx3{ii}{iii} = reshape(xx3{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
     end
     
      for ii=11
         for iii=[1:10,12:40]
         xx3{ii}{iii}=reshape(diff_real3{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q13{ii}{iii} = quantile(xx3{ii}{iii}, 0.25);
         q33{ii}{iii} = quantile(xx3{ii}{iii}, 0.75);
         iqr3{ii}{iii} = q33{ii}{iii} - q13{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len3 = 1:length(xx3{ii}{iii})
    if (xx3{ii}{iii}(len3) > q33{ii}{iii}+(iqr3{ii}{iii}*3)) || (xx3{ii}{iii}(len3) < q13{ii}{iii}-(iqr3{ii}{iii}*3))
        xx3{ii}{iii}(len3) = 0;
    end
         end

    noOutMtx3{ii}{iii} = reshape(xx3{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
      end
     
      for ii=12
         for iii=[1:14,16:30,32:40]
         xx3{ii}{iii}=reshape(diff_real3{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q13{ii}{iii} = quantile(xx3{ii}{iii}, 0.25);
         q33{ii}{iii} = quantile(xx3{ii}{iii}, 0.75);
         iqr3{ii}{iii} = q33{ii}{iii} - q13{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len3 = 1:length(xx3{ii}{iii})
    if (xx3{ii}{iii}(len3) > q33{ii}{iii}+(iqr3{ii}{iii}*3)) || (xx3{ii}{iii}(len3) < q13{ii}{iii}-(iqr3{ii}{iii}*3))
        xx3{ii}{iii}(len3) = 0;
    end
         end

    noOutMtx3{ii}{iii} = reshape(xx3{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
      end
     
       for ii=14
         for iii=[1:34,36:40]
         xx3{ii}{iii}=reshape(diff_real3{ii}{iii}, [290 1]); % matrix --> 1-D vector 
         q13{ii}{iii} = quantile(xx3{ii}{iii}, 0.25);
         q33{ii}{iii} = quantile(xx3{ii}{iii}, 0.75);
         iqr3{ii}{iii} = q33{ii}{iii} - q13{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len3 = 1:length(xx3{ii}{iii})
    if (xx3{ii}{iii}(len3) > q33{ii}{iii}+(iqr3{ii}{iii}*3)) || (xx3{ii}{iii}(len3) < q13{ii}{iii}-(iqr3{ii}{iii}*3))
        xx3{ii}{iii}(len3) = 0;
    end
         end

    noOutMtx3{ii}{iii} = reshape(xx3{ii}{iii}, [10 29]); %1-D Vector --> matrix
         end
       end
         %% CC-8�� ������ ����
   %29�� ä�ΰ� 16�� ������
for c = [5:6,10,13,15:19]%5,6,10,13,15,16,17,18,19��(sub3,4,8,11,13,14,15,16,17) train�Ǵ� ������
 for e = 16%16��(sub14) test �Ǵ� ������
  for test = 1:40%test �Ǵ� �������� trial
    for train=1:40%train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 3%3��(sub1) train�Ǵ� ������
 for e = 16%16��(sub14) test �Ǵ� ������
  for test = [1,3:39]%2,40 trial ���� 38�� test �Ǵ� �������� trial
    for train=[1,3:39]%2,40 trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 4%4��(sub2) train�Ǵ� ������
 for e =16%16��(sub14) test �Ǵ� ������
  for test = [1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� test �Ǵ� �������� trial
    for train=[1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 7%7��(sub5) train�Ǵ� ������
 for e = 16%16��(sub14) test �Ǵ� ������
  for test = [1:7,9:40]%8 trial ���� 39�� test �Ǵ� �������� trial
    for train=[1:7,9:40]%8 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 9%9��(sub7) train�Ǵ� ������
 for e = 16%16��(sub14) test �Ǵ� ������
  for test = 2:40%1 trial ���� 39�� test �Ǵ� �������� trial
    for train= 2:40%1  trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 11%11��(sub9) train�Ǵ� ������
 for e = 16%16��(sub14) test �Ǵ� ������
  for test = [1:10,12:40]%11 trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:10,12:40]%11 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 12%12��(sub10) train�Ǵ� ������
 for e = 16%16��(sub14) test �Ǵ� ������
  for test = [1:14,16:30,32:40]%15,31 trial ���� 38�� test �Ǵ� �������� trial
    for train= [1:14,16:30,32:40]%15,31 trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 14%14��(sub12) train�Ǵ� ������
 for e = 16%16��(sub14) test �Ǵ� ������
  for test = [1:34,36:40]%35 trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:34,36:40]%35 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

%16�������� train
for c = 16%16��(sub14) train�Ǵ� ������
 for e = [5:6,10,13,15:19]%5,6,10,13,15,16,17,18,19��(sub3,4,8,11,13,14,15,16,17) test �Ǵ� ������
  for test = 1:40%test �Ǵ� �������� trial
    for train=1:40%train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 16%16��(sub14) train�Ǵ� ������
 for e = 3%8��(sub1) test �Ǵ� ������
  for test = [1,3:39]%2,40 trial ���� 38�� test �Ǵ� �������� trial
    for train=[1,3:39]%2,40 trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 16%16��(sub14) train�Ǵ� ������
 for e = 4%4��(sub2) test �Ǵ� ������
  for test = [1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� test �Ǵ� �������� trial
    for train=[1:18,20:33,35,37:40]%19,34,36 trial ���� 37�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 16%16��(sub14) train�Ǵ� ������
 for e = 7%7��(sub5) test �Ǵ� ������
  for test = [1:7,9:40]%8 trial ���� 39�� test �Ǵ� �������� trial
    for train=[1:7,9:40]%8 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c =16%16��(sub14) train�Ǵ� ������
 for e = 9%9��(sub7) test �Ǵ� ������
  for test = 2:40%1 trial ���� 39�� test �Ǵ� �������� trial
    for train= 2:40%1  trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 16%16��(sub14) train�Ǵ� ������
 for e = 11%11��(sub9) test �Ǵ� ������
  for test = [1:10,12:40]%11 trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:10,12:40]%11 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 16%16��(sub14) train�Ǵ� ������
 for e = 12%12��(sub10) test �Ǵ� ������
  for test = [1:14,16:30,32:40]%15,31 trial ���� 38�� test �Ǵ� �������� trial
    for train= [1:14,16:30,32:40]%15,31 trial ���� 38�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 16%16��(sub14) train�Ǵ� ������
 for e = 14%14��(sub12) test �Ǵ� ������
  for test = [1:34,36:40]%35 trial ���� 39�� test �Ǵ� �������� trial
    for train= [1:34,36:40]%35 trial ���� 39�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx3{e}{test}.*noOutMtx3{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx3{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx3{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for e=16%16��(sub6) ������
    for test=1:40
    Mean{e,e}(test)=(sum(CC{e,e}(test,:))-1)/39;% �ڱ� �ڽŰ� �������� mean
    end
end
%% 8��, 16�� ������ ä�� ä��-��ü�� ä���� �� �����ϴ���
 for num=[15:16,31:32]%8,15��������(sub6,14) 1session 
   rowdata4{num} = [data{num}(:,2:3),data{num}(:,5:8),data{num}(:,10),data{num}(:,13:25),data{num}(:,27:28),data{num}(:,30:32)];%data 1~2,4~7,9,12~24,26~27,29~31ch 
   cardata4{num} = rowdata4{num}-repmat(mean(rowdata4{num},2), 1, 25);%CAR x���� ä��, y���� �ð�
    
   Wn=[1 45]; %���ļ��뿪
   [b,a]=butter(3, Wn/512, 'bandpass');%Butter 
   Y4{num} = filter(b,a, cardata4{num});%filtering
 end
 
%% ������ diff
for n=[15:16,31:32] % 8,16�� ������(sub1) 1session 
  for trial15 = 1:20% 20�� trial
  
       op4{n}= Y4{n}(((trial15-1)*30.5+21-eo)*512:((trial15-1)*30.5+21)*512,:);
       cl4{n}= Y4{n}(((trial15-1)*30.5+21)*512:((trial15-1)*30.5+21+ec)*512,:);
         
        for chIdx4 = 1:25
           [so4{n}, fo4{n}, to4{n}, po4{n}(:,:,chIdx4)] = spectrogram(op4{n}(:,chIdx4),window,overlap,N,fs);%spectrogramǥ��
           [sc4{n}, fc4{n}, tc4{n}, pc4{n}(:,:,chIdx4)] = spectrogram(cl4{n}(:,chIdx4),window,overlap,N,fs);
        end
         mean_po4{n}=mean(po4{n},2);%�� trial ���� ���
         mean_pc4{n}=mean(pc4{n},2);
         
         diff4{n}=mean_pc4{n} - mean_po4{n};%��հ� close-open ����
         diff_reall4{n}{trial15}=abs(diff4{n}(7:16,:));%6~15hz ���� ���캽-0hz�� �ش��ϴ� �͵� �����������(fo or fc�� Ȯ��)
  end
end
  
   for ii= [8,16]%2session ��ġ��
     diff_real4{ii}=([diff_reall4{2*ii-1},diff_reall4{2*ii}]);
   end
   %% outlier
    for ii=[8,16]
         for iii=1:40
         xx4{ii}{iii}=reshape(diff_real4{ii}{iii}, [250 1]); % matrix --> 1-D vector 
         q14{ii}{iii} = quantile(xx4{ii}{iii}, 0.25);
         q34{ii}{iii} = quantile(xx4{ii}{iii}, 0.75);
         iqr4{ii}{iii} = q34{ii}{iii} - q14{ii}{iii}; %inter qurtile range: Q3 - Q1
      
         for len4 = 1:length(xx4{ii}{iii})
    if (xx4{ii}{iii}(len4) > q34{ii}{iii}+(iqr4{ii}{iii}*3)) || (xx4{ii}{iii}(len4) < q14{ii}{iii}-(iqr4{ii}{iii}*3))
        xx4{ii}{iii}(len4) = 0;
    end
         end

    noOutMtx4{ii}{iii} = reshape(xx4{ii}{iii}, [10 25]); %1-D Vector --> matrix
         end
     end
 %% cc
for c = 8%8��(sub6) train�Ǵ� ������
 for e = 16%16��(sub14) test �Ǵ� ������
  for test = 1:40%40�� test �Ǵ� �������� trial
    for train= 1:40%40�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx4{e}{test}.*noOutMtx4{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx4{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx4{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end

for c = 16%16��(sub14) train�Ǵ� ������
 for e = 8%8��(sub6) test �Ǵ� ������
  for test = 1:40% 40�� test �Ǵ� �������� trial
    for train= 1:40% 40�� train�� �Ǵ� �������� trial
        nume{e,c}(test,train) = sum(sum(noOutMtx4{e}{test}.*noOutMtx4{c}{train}));%����
        de_test{e}(test)=sum(sum(noOutMtx4{e}{test}.^2));%�и𿡼� test �κ�
        de_train{c}(train)=sum(sum(noOutMtx4{c}{train}.^2));%�и𿡼� train �κ�
        deno{e,c}(test,train)=sqrt(de_test{e}(test).*de_train{c}(train));%�и�
         
        CC{e,c}(test,train)=nume{e,c}(test,train)/deno{e,c}(test,train);%CC��
        Mean{e,c}(test)=mean(CC{e,c}(test,:));%cc ���
    end
  end
 end
end
%% �з���Ȯ��
for dd=3:19
Mean{3,dd}(40)=0;
Mean{dd,3}(40)=0;
end

for dd=3:19%�ִ� ã�� ���� �����۾�/1��°�� �������� �� cc�� �� 1��° ���� ����,2��° ����...40��°������, 2��°�� ���ص� ����������
        findmax22{dd}=[zeros(1, 40); zeros(1, 40);Mean{dd,3};Mean{dd,4};Mean{dd,5};Mean{dd,6};Mean{dd,7};Mean{dd,8};...
            Mean{dd,9};Mean{dd,10};Mean{dd,11};Mean{dd,12};Mean{dd,13};Mean{dd,14};Mean{dd,15};Mean{dd,16};Mean{dd,17};Mean{dd,18};Mean{dd,19}];   
end
count = zeros(19,1);

 for d= [1,3:39]%2,40 ���� 38�� trial
           if max(findmax22{3}(3:19,d)) == findmax22{3}(3,d)
          disp('����')
             count(3)  = count(3) + 1;
          end
 end

     for d=[1:18,20:33,35,37:40]%19,34,36 ����      
          if max(findmax22{4}(3:19,d)) == findmax22{4}(4,d)
          disp('����');
             count(4)  = count(4) + 1;
          end
     end
     
    for d= 1:40      
          if max(findmax22{5}(3:19,d)) == findmax22{5}(5,d)
          disp('����');
             count(5)  = count(5) + 1;
          end
    end    
  for d= 1:40
          if max(findmax22{6}(3:19,d)) == findmax22{6}(6,d)
          disp('����');
             count(6)  = count(6) + 1;
          end
  end
  for d= [1:7,9:40] %8trial ���� 39��
          if max(findmax22{7}(3:19,d)) == findmax22{7}(7,d)
          disp('����');
             count(7)  = count(7) + 1;
          end
  end
  for d= 1:40
          if max(findmax22{8}(3:19,d)) == findmax22{8}(8,d)
          disp('����');
             count(8)  = count(8) + 1;
          end
  end
  for d= 2:40 %1���� 39
          if max(findmax22{9}(3:19,d)) == findmax22{9}(9,d)
          disp('����');
             count(9)  = count(9) + 1;
          end
  end
  for d= 1:40
          if max(findmax22{10}(3:19,d)) == findmax22{10}(10,d)
          disp('�ؿ�');
             count(10)  = count(10) + 1;
          end
  end
  for d= [1:10,12:40] %11����39
          if max(findmax22{11}(3:19,d)) == findmax22{11}(11,d)
          disp('����');
             count(11)  = count(11) + 1;
          end
  end
  for d= [1:14,16:30,32:40]%15,31����38
          if max(findmax22{12}(3:19,d)) == findmax22{12}(12,d)
          disp('����');
             count(12)  = count(12) + 1;
          end
  end
 for d= 1:40
          if max(findmax22{13}(3:19,d)) == findmax22{13}(13,d)
          disp('����');
             count(13)  = count(13) + 1;
          end
 end
 for d= [1:34,36:40]%35���� 39
          if max(findmax22{14}(3:19,d)) == findmax22{14}(14,d)
          disp('�α�');
             count(14)  = count(14) + 1;
          end
 end
 for d= 1:40
          if max(findmax22{15}(3:19,d)) == findmax22{15}(15,d)
          disp('����');
             count(15)  = count(15) + 1;
          end
 end
 for d= 1:40
          if max(findmax22{16}(3:19,d)) == findmax22{16}(16,d)
          disp('����');
             count(16)  = count(16) + 1;
          end
 end
 for d= 1:40
          if max(findmax22{17}(3:19,d)) == findmax22{17}(17,d)
          disp('����');
             count(17)  = count(17) + 1;
          end
 end
 for d= 1:40
          if max(findmax22{18}(3:19,d)) == findmax22{18}(18,d)
          disp('��ȿ');
             count(18)  = count(18) + 1;
          end
 end
 for d= 1:40
          if max(findmax22{19}(3:19,d)) == findmax22{19}(19,d)
          disp('����');
            count(19)  = count(19) + 1;
          end
 end