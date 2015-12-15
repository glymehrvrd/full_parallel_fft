function [result,eachclass]=fft4(data)
    for i=1:2
        left_outputs(i,:)=fft2(data(i:2:end));
    end;
    left_outputs=left_outputs.';

    right_inputs=left_outputs;
    right_inputs(4)=complex(imag(left_outputs(4)),-real(left_outputs(4)));

    for j=1:2
        right_outputs(j,:)=fft2(right_inputs(j,:));
    end;
    eachclass={left_outputs(:),right_outputs(:)};
    result=right_outputs(:);
end