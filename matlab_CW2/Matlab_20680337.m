%% PRELIMINARY TASK - MATLAB talks to Arduino

% Clear existing Arduino object if present
clear a  
% 1. Create the Arduino object
a = arduino('COM3', 'Uno');

% 2. Test the LED manually
writeDigitalPin(a, 'D10', 1);   % LED ON
pause(1);
writeDigitalPin(a, 'D10', 0);   % LED OFF
for i = 1:10  % Blink 10 times
    writeDigitalPin(a, 'D10', 1);   % LED ON
    pause(0.5);                     % Wait 0.5 s
    writeDigitalPin(a, 'D10', 0);   % LED OFF
    pause(0.5);                     % Wait 0.5 s
end

clear a  

a = arduino('COM3','Uno');

duration = 10; % test with 10 seconds first
time = zeros(1, duration);
voltage = zeros(1, duration);

for i = 1:duration
    time(i) = i;
    voltage(i) = readVoltage(a, 'A0');
    
    pause(1);
end
V0 = 0.5;
TC = 0.01;

temperature = (voltage - V0) / TC;

disp(temperature);
plot(time, temperature);
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Temperature vs Time');

