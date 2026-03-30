
% Temp_moniter records temperature and controls LEDs in real-time.
% This function continuously reads the temperature from a TMP36 sensor connected to the Arduino object 'a' on analog pin A0. 
% It plots a live scrolling graph of the temperature (updating every second)
% It also controls three LEDs according to the measured temperature:
% Green LED: constant on for 18-24°C
% Yellow LED: blinking for temperatures below 18°C
% Red LED: blinking for temperatures above 24°C
% Inputs:
%   a        - Arduino object
%   greenPin - Digital pin connected to green LED
%   yellowPin- Digital pin connected to yellow LED
%   redPin   - Digital pin connected to red LED
%
% The function runs indefinitely until manually stopped (Ctrl+C).


function temp_monitor(a, greenPin, yellowPin, redPin)

% Set the initial state of the LEDs

writeDigitalPin(a,greenPin, 0);  %digital pin connnected to green LED is off initally
writeDigitalPin(a,yellowPin, 0); %digital pin connnected to yellow LED is off initally
writeDigitalPin(a,redPin, 0);    %digital pin connnected to red LED is off initally

timeData= [];  %creates empty arrays to store time values
tempData= [];  %creates empty array to store temperature values

figure;                                        %opens a new figure window
hPlot = plot(NaN, NaN, 'b', 'LineWidth', 2);   %begins a plot with no data
xlabel('Time (s)');                            %label X-axis
ylabel('Temperature (°C)');                    %label Y-axis
title('Live Temperature Monitor');             %plot title
xlim([0 60]);                                  %initially display 60 seconds on X-axis, before it moves along
ylim([0 40]);                                  %Y-axis covers expected temperature range
grid on;                                       %turn on grid for easier reading

 tic;                               %start timer to measure elapsed time
while true   
 t = toc;                           %get elapsed time since tic
   
analogValue = readVoltage(a, 'A0'); % read voltage from thermistor
temp = (analogValue - 0.5) * 100;   % simple TMP36 conversion example

    % Store data for plotting
    timeData(end+1) = t;            %adds the current elapsed time t to the array
    tempData(end+1) = temp;         %adds the current temperature reading to the array


    set(hPlot, 'XData', timeData, 'YData', tempData); % Update plot data
    xlim([max(0, t-60), t]);                          % Scroll the last 60 seconds on X-axis
    drawnow;                                          % Refresh figure window with updated data
    

   
  % LED control logic
    if temp < 18
        % Yellow blink every 0.5s
        writeDigitalPin(a, greenPin, 0);  %turn off green
        writeDigitalPin(a, redPin, 0);    %turn off red
        writeDigitalPin(a, yellowPin, 1); %turn on yellow
        pause(0.25);                      %waits 0.25seconds
        writeDigitalPin(a, yellowPin, 0); %turns off yellow
        pause(0.25);                      %waits 0.25s again
        
    elseif temp <= 24
        % Green solid
        writeDigitalPin(a, greenPin, 1);  %turns on green
        writeDigitalPin(a, yellowPin, 0); %turns off yellow
        writeDigitalPin(a, redPin, 0);    %turns off red
        pause(1);                         %1s interval for plot 

    else
        % Red blink every 0.25s
        writeDigitalPin(a, greenPin, 0);  %turns off green
        writeDigitalPin(a, yellowPin, 0); %turns off yellow
        writeDigitalPin(a, redPin, 1);    %turns on red
        pause(0.125);                     %waits 0.125 secs 
        writeDigitalPin(a, redPin, 0);    %before it turns off (faster blinking)
        pause(0.125);                     %waits 0.125secs before it foes this again
    end
end
end

