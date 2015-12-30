function [result,eachclass]=fft4(data,bypass)
    if nargin==1
        bypass=[0 0];
    end;

    for i=1:2
        left_outputs(i,:)=fft2(data(i:2:end),bypass(1));
    end;
    left_outputs=left_outputs.';

    right_inputs=left_outputs;
    if bypass(1)~=1
        right_inputs(4)=complex(imag(left_outputs(4)),-real(left_outputs(4)));
    end;

    for j=1:2
        right_outputs(j,:)=fft2(right_inputs(j,:),bypass(2));
    end;
    eachclass={left_outputs(:),right_outputs(:)};
    result=right_outputs(:);
end