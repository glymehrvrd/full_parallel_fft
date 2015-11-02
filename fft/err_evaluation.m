err=hardware_out-float_out;
err=err(:);

figure;
subplot(3,1,1);
stem(real(err)./real((hardware_out(:)+float_out(:))/2));
title('real part error ratio');

subplot(3,1,2);
stem(imag(err)./imag((hardware_out(:)+float_out(:))/2));
title('imaginary part error ratio');

subplot(3,1,3);
stem(abs(err)./abs((hardware_out(:)+float_out(:))/2))
title('total error ratio');