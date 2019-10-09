%% build SPI connection
pi4 = raspi('192.168.1.34','pi','ratmania');
enableSPI(pi4);
counter = spidev(pi4,'CE0');

%% Initialize counter chip to quadrature mode
MDR1_Binary = '11000001';
writeRead(counter,[hex2dec('88') hex2dec('3')]);%set quadrature mode: Write to MDR0+ settings
% D3:  filter clock division factor = 1 , Synchronous Index, load CNTR, free-running count, x4 quadrature count mode 
%53, filter clock division factor = 0, rest the same
% 3: disable index function, quadrature mode
writeRead(counter,[hex2dec('90') bin2dec(MDR1_Binary)]);%set flags: write to MDR1, 3-byte counter + flags: NOP
% %% read counter value
% data = writeRead(counter,[hex2dec('60') hex2dec('FF') hex2dec('FF') hex2dec('FF']);%transfer CNTR to OR and send through SPI
% 
% %% clear counter
% writeRead(counter,hex2dec('20'));