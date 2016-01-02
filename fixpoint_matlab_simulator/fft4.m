function [result]=fft4(data,bypass,ordertest)

    if nargin==1
        bypass=[0 0];
        ordertest=false;
    elseif nargin==2
        ordertest=false;
    end;

    if ordertest&&~bypass(1)
        result=data;
    else
        left_outputs=int16(zeros(2,2));
        for i=1:2
            left_outputs(i,:)=fft2(data(i:2:end),bypass(1),ordertest);
        end;
        left_outputs=left_outputs.';

        right_inputs=left_outputs;
        if ~(bypass(1)||ordertest)
            right_inputs(4)=complex(imag(left_outputs(4)),-real(left_outputs(4)));
        end;

        right_outputs=int16(zeros(2,2));
        for j=1:2
            right_outputs(j,:)=fft2(right_inputs(j,:),bypass(2),ordertest);
        end;
        result=right_outputs(:);
    end;
end