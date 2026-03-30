%% PRELIMINARY TASK - MATLAB talks to Arduino


clear a                     %clear existing Arduino object if present
a = arduino('COM3', 'Uno'); %create the Arduino object

%Test the LED manually

writeDigitalPin(a, 'D10', 1);       %LED ON
pause(1);                           %waits for 1 second
writeDigitalPin(a, 'D10', 0);       %LED OFF
for i = 1:10                        %blinks 10 times
    writeDigitalPin(a, 'D10', 1);   %LED ON
    pause(0.5);                     %wait 0.5 s
    writeDigitalPin(a, 'D10', 0);   %LED OFF
    pause(0.5);                     %wait 0.5 s
end
%-------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------------------------

%% TASK 1 - MATLAB 
clear a  

a = arduino('COM3','Uno');             %connects matlab to the arduino board

duration = 10;                         %sets it to be recorded for 600seconds
time = zeros(1, duration);             %stores array of time
voltage = zeros(1, duration);          %stores arrays of voltage values

for i = 1:duration                     %allows the loop to run once every sec
    time(i) = i;                       %stores time in seconds
    voltage(i) = readVoltage(a, 'A0'); %reads voltage from analouge pin A0
    
    pause(1);                          %waits one sec beforw the next reading
end
disp(voltage);                         %displays all recorded voltages

V0 = 0.5;                              %voltage at 0deg (found in thermistor data sheet)
TC = 0.01;                             %temperature coefficient (found in thermistor data sheet)

temperature = (voltage - V0) / TC      % Convert voltage values into temperature where V0 is the voltage at 0deg


disp(temperature);            %display calculated temp
plot(time, temperature);      %plots a graph of temperature against time
xlabel('Time (s)');           %label x axis
ylabel('Temperature (°C)');   %label y axis
title('Temperature vs Time'); %add a title

minTemp = min(temperature);  %find the minimum temp
maxTemp = max(temperature);  %find maximum temp
avgTemp = mean(temperature); %calculate average

%display the results to 2dp
fprintf('Min: %.2f °C\n', minTemp);
fprintf('Max: %.2f °C\n', maxTemp);
fprintf('Avg: %.2f °C\n', avgTemp);

for i = 1:60:length(temperature) %loops through the data every 60s
    minute = (i-1)/60;           %converts it to minutes
    
    str = sprintf('Minute %d\tTemperature: %.2f °C',minute, temperature(i));  %creates a string of the temperature and minutes to 2dp
    
    disp(str);                                                                %display the sting
end

fileID = fopen('capsule_temperature.txt','w');                                %open a text file for writing

for i = 1:60:length(temperature)                                              %loop data every 60s
    minute = (i-1)/60;                                                        %converts to minutes
    
    fprintf(fileID, 'Minute %d\tTemperature: %.2f °C\n',minute, temperature(i));
end

% Write statistics at the end of the file
fprintf(fileID, '\nMinimum Temperature: %.2f °C\n', minTemp);
fprintf(fileID, 'Maximum Temperature: %.2f °C\n', maxTemp);
fprintf(fileID, 'Average Temperature: %.2f °C\n', avgTemp);

fclose(fileID);  %clese the file