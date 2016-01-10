function [result]=fft2_float(data)

    result = fft(data);
    % global f;
    % sprintf('data: %d %d\n',real(data(1)),imag(data(1)))
    % sprintf('data: %d %d\n',real(data(2)),imag(data(2)))
    % sprintf('result: %d %d\n',real(result(1)),imag(result(1)))
    % sprintf('result: %d %d\n',real(result(2)),imag(result(2)))

    % fwrite(f,sprintf('din\n'));
    % fwrite(f,sprintf('%d %d\n',real(data(1)),imag(data(1))));
    % fwrite(f,sprintf('%d %d\n',real(data(2)),imag(data(2))));
    % fwrite(f,sprintf('\n'));
    % fwrite(f,sprintf('dout\n'));
    % fwrite(f,sprintf('%d %d\n',real(result(1)),imag(result(1))));
    % fwrite(f,sprintf('%d %d\n',real(result(2)),imag(result(2))));
    % fwrite(f,sprintf('\n'));
end