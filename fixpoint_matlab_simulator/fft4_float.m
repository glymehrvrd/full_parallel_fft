function [result,eachclass]=fft4(data)
    for i=1:2
        left_outputs(i,:)=fft(data(i:2:end));
    end;
    left_outputs=left_outputs.';

    right_inputs=left_outputs;
    right_inputs(4)=left_outputs(4).*(-1j);

    for j=1:2
        right_outputs(j,:)=fft(right_inputs(j,:));
    end;
    eachclass={left_outputs(:),right_outputs(:)};
    result=right_outputs(:);
end