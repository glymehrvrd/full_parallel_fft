function [result,eachclass]=fft3(data)
    
    t31=complexadd(data(2),data(3));
    t32=complexsub(data(3),data(2));
    
    m31=complexadd(data(1),t31);
    
    m32=complex(bitshift(real(t31),-1),bitshift(imag(t31),-1));
    m32=complexadd(m32,t31);
    m32=complexsub(0,m32);
    m33=complex(-mul(imag(t32),28378),mul(real(t32),28378));
    
    s31=complexadd(m31,m32);
    
    x31=m31;
    x32=complexadd(s31,m33);
    x33=complexsub(s31,m33);
    
    result=[x31,x32,x33];
    eachclass={result(:)};
end