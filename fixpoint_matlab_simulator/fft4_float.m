function [result]=fft4_float(data)
    left_outputs=zeros(2,2);
    for i=1:2
        left_outputs(i,:)=fft(data(i:2:end));
    end;
    left_outputs=left_outputs.';

    right_inputs=left_outputs;
    right_inputs(4)=left_outputs(4).*(-1j);

    right_outputs=zeros(2,2);
    for j=1:2
        right_outputs(j,:)=fft(right_inputs(j,:));
    end;
    result=right_outputs(:);
end