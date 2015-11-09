function [result]=fft4(data)
    % m=2;
    % n=2;
    % [index,w]=calc_param(2,2);
    % w=reshape(w,m,n);
    % w=sfi(w,16,15);
    
    % left_outputs=zeros(n,m);
    % for i=1:n
    %     left_outputs(i,:)=fft2(data(i:n:end));
    % end;

    % right_inputs=(left_outputs.').*w;
    % right_inputs=fi(right_inputs,1,16,0,'RoundMode','floor');
    % right_inputs=right_inputs(index+1);

    % right_outputs=zeros(m,n);
    % for j=1:m
    %     right_outputs(j,:)=fft2(right_inputs(j,:));
    % end;
    % result=right_outputs(:);
    result=sfi(zeros(1,4),16,0);
    result(1)=data(1)+data(2)+data(3)+data(4);
    result(2)=data(1)-1j*data(2)-data(3)+1j*data(4);
    result(3)=data(1)-data(2)+data(3)-data(4);
    result(4)=data(1)+1j*data(2)-data(3)-1j*data(4);
    result=fi(result,1,16,0,'RoundMode','floor');
end