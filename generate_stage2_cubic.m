load("stage2params.mat")
M = 200; 
root="./more/misclassified/";
parfor i=1:length(cubicparameters)
para=cubicparameters(:,i)';
vel_plane=cubic(para(1)).velocity(para(2),para(3),:);
% select 60 degreee plane in titanium (Hearmon)
%ke_vel= vel_plane;
vel = vel_plane;%velocity model for one plane (1,181)
velrot =circshift(vel,para(4));
%rawdata_interval = rawdatainterval(j); %step between 
rawdata_interval =para(5);
lambda = 24e-6; %Acoutsic wavelength
no_fringes = para(6); %number of fringes used in the acoutic generation patch
%noise_std = 0.16*j; %experimental noise level
noise_std = para(7);
vrange = [0 6000]; % velocity range, you might need to adjust this
lambda_error = []; % systematic error in the experiment, ignore for now
%random_noise_proportion = 0.1*j; %   when ==1, there isnt any systematic noise
random_noise_proportion = para(8);
[v_axis,deg_pace_180,rawdata_180,vel,wave_out,time_axis]=model_to_rawdata_ver2(velrot, rawdata_interval, lambda, no_fringes, noise_std, vrange, lambda_error, random_noise_proportion);
rawdata = [squeeze(rawdata_180(:,1:end-1)) squeeze(rawdata_180(:,1:end-1))].';

name=cubic(:,para(1));
filename=strcat(root,name,"/",name,"-1vel",string(para(2)),"-2vel",string(para(3)),"-ro",string(para(4)), ...
                 "-it",string(rawdata_interval),"-fr",string(fringes), ...
                          "-wv24","-ns",string(noise_std*100), ...
                         "-rand",string(random_noise_proportion*100),".png");

%changes the size of the image and the resolution
% figure(2);colormap jet;
imP = PolarToIm(circshift(rawdata',90,2),0,1,M,M);
imP = rescale(imP,0,256);
% imagesc(imP) % now have them 
% axis square
imwrite(ind2rgb(im2uint8(mat2gray(imP)), jet(256)),filename);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [v_axis,deg_pace_180,rawdata_180,vel,wave_out,time_axis]=model_to_rawdata_ver2(vel, rawdata_interval, lambda, no_fringes, noise_std, vrange, lambda_error, random_noise_proportion)
if ~exist('lambda_error', 'var') || isempty(lambda_error)
    lambda_error.rand_error = 0;
    lambda_error.dc_error =0;
end

deg_pace_180=0:rawdata_interval:(180);
npad = 4096;  %4096;

sampling_rate = 1e-9;
time_axis = 0:sampling_rate:(lambda/2000)*(no_fringes+5);
[~,faxis]=fftaxis(time_axis,npad);

[~,vrange_min] = min(abs(faxis*lambda-vrange(1)));
[~,vrange_max] = min(abs(faxis*lambda-vrange(2)));
v_axis = faxis(vrange_min:vrange_max)*lambda;
load('system_noise.mat');system_noise = system_noise(1:length(time_axis));
for i=1:length(deg_pace_180)
    mod1 = vel(rawdata_interval*i-rawdata_interval+1)*(1+rand(1)*10*lambda_error.rand_error + lambda_error.dc_error);

    fre_tmp = mod1/lambda;
    sine_wave = sin(fre_tmp.*time_axis*2*pi);

    cycle = 1/fre_tmp;
    envelope = make_gauss(time_axis,[1 cycle*no_fringes/2 time_axis(round(length(time_axis)/2))].').'; 
    random_noise=noise_std.*randn([1 length(time_axis)]);
    signal = sine_wave.*envelope.*(-envelope);
    noise = system_noise*(1-random_noise_proportion)+random_noise*random_noise_proportion;
    wave_form = signal + noise;
    wave_out(:,i) = wave_form;
    final_wave = abs(fft(wave_form,npad));
    %snr_tmp(i) = snr(signal, noise); %requires signal processing toolbox
    
rawdata_180(:,i) = final_wave(vrange_min:vrange_max);
    
end
%SNR = mean(snr_tmp);
end


%gauss_data=make_gauss(x,params)
%
%params = [amp width position]
function gauss_data=make_gauss(x,gauss)

s=size(gauss,2);
gauss_data=zeros(length(x),s);
for l=1:s
	gauss_data(:,l)=gauss(1,l).*exp(-((x-gauss(3,l)).^2)./(gauss(2,l).^2));
	end;
end

function [z,z_not_shifted]=fftaxis(t,N)
%[z,z_not_shifted]=fftaxis(t,N)
%
%Returns the frequency axis for a given time axis.
%N is the number of points in the FFT, if this is empty or not
%supplied, then length(t) is used instead.
%
%"z" will run from -max(freq) to +max(freq) (where max(freq) = Nyquist)
%"z_not_shifted" will run from 0 to 2*max(freq), and the scale
%will not be valid beyond max(freq)

if nargin < 2 N = [];end;
if isempty(N)
	s=length(t);
else
	s=N;
end

h_int=(t(2)-t(1))*s;

%% produces the z-axis... fine up till 1/2 way
z_not_shifted=[0:(s-1)]*(1/h_int);

%% the following line produces the real scale, but it doesn't plot
%% correctly
z=[(-s/2)+1:s/2]*(1/h_int);

end

function polar_view(angular_axis, linear_axis, vel, opt, threshold, vrange, disk_or_ring, disk_size, axis_range)
%   [X, Y, vel_polar, opt_polar] = polar_view(angular_axis, linear_axis, vel, opt, threshold, vrange, disk_or_ring, disk_size, axis_range)
% angular_axis doesnt have to be [0 360] but should be the same size as size(vel, 1)
% linear_axis can be larger than size(vel,2) when only scan an outter ring of the disk
if nargin < 4 opt = zeros(size(vel))+1; end
if nargin < 5 threshold = 1; end
if nargin < 6 vrange = [2600 3400]; end
if nargin < 7 disk_or_ring = 0; end
if nargin < 8 disk_size = max(linear_axis); end
if nargin < 9 axis_range = []; end

if disk_or_ring == 1
    linear_axis = 0:(linear_axis(2)-linear_axis(1))/1e3:disk_size;
else
    linear_axis = max(linear_axis)-linear_axis;
end
if isempty(axis_range)
    axis_range = [-max(linear_axis) max(linear_axis) -max(linear_axis) max(linear_axis) vrange];
end

angular_axis2 = 0:angular_axis(2)-angular_axis(1):360;
[xx,yy]=meshgrid(angular_axis2/180*pi, linear_axis);
[X,Y] = pol2cart(xx,yy);

if isempty(vel)
    opt_polar = zeros(length(angular_axis2), length(linear_axis));
    opt_polar(1:size(opt,1),1:size(opt,2)) = opt;
    opt_polar(opt_polar==0) = nan;
    if angular_axis(end) == 360-angular_axis(2)+angular_axis(1)
        opt_polar(end,1:size(opt,2)) = opt(1,:);
    end
    surf(X,Y,flipud(opt_polar.'));
    colormap(gca,'gray');
else
    vel_polar = zeros(length(angular_axis2), length(linear_axis));
    vel_polar(1:size(opt,1),1:size(opt,2)) = vel;
    opt_polar = zeros(length(angular_axis2), length(linear_axis));
    opt_polar(1:size(opt,1),1:size(opt,2)) = opt;
    if angular_axis(end) == 360-angular_axis(2)+angular_axis(1)
        vel_polar(end,1:size(vel,2)) = vel(1,:);
        opt_polar(end,1:size(vel,2)) = opt(1,:);
    end
    surf(X,Y,flipud((vel_polar.*(opt_polar>=threshold)).'));
    colormap(gca,'jet');
    
end
caxis(vrange)
axis image
axis(axis_range)
shading interp
view(0, 90)
grid off
colorbar;
end

function imR = PolarToIm (imP, rMin, rMax, Mr, Nr)
imR = zeros(Mr, Nr);
Om = (Mr+1)/2; % co-ordinates of the center of the image
On = (Nr+1)/2;
sx = (Mr-1)/2; % scale factors
sy = (Nr-1)/2;
[M N] = size(imP);
delR = (rMax - rMin)/(M-1);
delT = 2*pi/N;
for xi = 1:Mr
for yi = 1:Nr
    x = (xi - Om)/sx;
    y = (yi - On)/sx;
    r = sqrt(x*x + y*y);
    if r >= rMin & r <= rMax
       t = atan2(y, x);
       if t < 0
           t = t + 2*pi;
       end
       imR (xi, yi) = interpolate (imP, r, t, rMin, rMax, M, N, delR, delT);
    end
end
end
end

function v = interpolate (imP, r, t, rMin, rMax, M, N, delR, delT)
    ri = 1 + (r - rMin)/delR;
    ti = 1 + t/delT;
    rf = floor(ri);
    rc = ceil(ri);
    tf = floor(ti);
    tc = ceil(ti);
    if tc > N
        tc = tf;
    end
    if rf == rc & tc == tf
        v = imP (rc, tc);
    elseif rf == rc
        v = imP (rf, tf) + (ti - tf)*(imP (rf, tc) - imP (rf, tf));
    elseif tf == tc
        v = imP (rf, tf) + (ri - rf)*(imP (rc, tf) - imP (rf, tf));
    else
       A = [ rf tf rf*tf 1
             rf tc rf*tc 1
             rc tf rc*tf 1
             rc tc rc*tc 1 ];
       z = [ imP(rf, tf)
             imP(rf, tc)
             imP(rc, tf)
             imP(rc, tc) ];
       a = A\double(z);
       w = [ri ti ri*ti 1];
       v = w*a;
    end
end