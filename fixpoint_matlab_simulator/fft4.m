function [result]=fft4(data)
%     r=real(data);
%     i=imag(data);
%     result(1)=complex(r(1)+r(2)+r(3)+r(4)...
%         ,i(1)+i(2)+i(3)+i(4));
% 
%     result(2)=complex(r(1)+i(2)-r(3)-i(4)...
%         ,i(1)-r(2)-i(3)+r(4));
% 
%     result(3)=complex(r(1)-r(2)+r(3)-r(4)...
%         ,i(1)-i(2)+i(3)-i(4));
% 
%     result(4)=complex(r(1)-i(2)-r(3)+i(4)...
%         ,i(1)+r(2)-i(3)-r(4));

    for i=1:2
        left_outputs(i,:)=fft2(data(i:2:end));
    end;
    left_outputs=left_outputs.';

    right_inputs=left_outputs;
    right_inputs(4)=complex(imag(left_outputs(4)),-real(left_outputs(4)));

    for j=1:2
        right_outputs(j,:)=fft2(right_inputs(j,:));
    end;
    result=right_outputs(:);
end