% Example Code for Using ROS with Matlab
%
% This script creates a plot that shows three simulated LEDs. Your goal is
% to fill in the section titled "WRITE YOUR PUBLISHERS AND SUBSCRIBERS
% HERE" and write a subscriber to the "/keypress" topic to read in the
% keyboard character, then write three publishers for each of the LED
% topics ("/red_led", "/green_led", "/blue_led"). Start out with turning
% the LEDs on and off whenever the user presses the 'r', 'g' and 'b' keys.
% If the red LED is currently off when the 'r' key is pressed, turn the LED
% on. If it is currently on when the LED is pressed, turn the LED off. When
% you have successfully implemented this feature have some fun with it and
% make your own unique pattern with any key sequence.
%
% Once you understand how publishers and subscribers work, feel free to
% make a copy of this code and change it up. Remove the three subscribers
% and combine it into a single subscriber that uses a "std_msgs/UInt8"
% message type. Then control the LEDs based on the number that is sent.
%
% Notes
%------------
%   Be aware that the keys can only be read when the figure is in the
%   front. If you click on another window and start typing, it will not be
%   recognized. If you want the figure to always stay in the front as long
%   as your Matlab window is in the front, then uncomment the line that
%   says "figure(1);" in the while loop of the "Main Loop" section of this
%   code.
%
% ROS Topics
%------------
%   Published Topics
%   /keypress
%   Message Type: std_msgs/Char
%   Info: ASCII number of the key pressed by the keyboard, 'r' = 114, 
%   'g' = 103, 'b' = 98
%
%   Subscribed Topics
%   /red_led
%   Message Type: std_msgs/Bool
%   Info: Reads whether to turn ON (true) or OFF (false) the red LED
%   
%   /green_led
%   Message Type: std_msgs/Bool
%   Info: Reads whether to turn ON (true) or OFF (false) the green LED
%
%   /blue_led
%   Message Type: std_msgs/Bool
%   Info: Reads whether to turn ON (true) or OFF (false) the blue LED
%
%   Author: Kyle Larsen
%   Date: 30 Mar 2020

%=========================================================================%
% Set Global Parameters
%=========================================================================%
% When set to 'true' the program ends
% this is set to true in the callback function when the "close figure"
% button is pressed.
global quit_program;
quit_program = false;


%=========================================================================%
% Initialize ROS
%=========================================================================%
% Start the ROS Master
try
    rosinit;
catch
end

% Create the keypress publisher
% (publishes the character of the key that was pressed)
keypress_pub = rospublisher('/keypress', 'std_msgs/Char');
keypress_msg = rosmessage(keypress_pub);

% Create subscribers to the LED topics
% (if you publish 'True' to these topics, their respective LEDs will turn
% ON, if you publish 'False' they will turn OFF)
red_LED_sub = rossubscriber('/red_led', 'std_msgs/Bool', @redLEDCallback);
green_LED_sub = rossubscriber('/green_led', 'std_msgs/Bool', @greenLEDCallback);
blue_LED_sub = rossubscriber('/blue_led', 'std_msgs/Bool', @blueLEDCallback);


%=========================================================================%
% Create GUI Window
%=========================================================================%
global gui_parameters
gui_parameters = struct;
% Create a blank image
close all;
gui_parameters.gui_figure = figure(1);
gui_parameters.gui_axes = axes;
gui_parameters.gui_axes.XLim = [0 4];
gui_parameters.gui_axes.YLim = [0 2];
axis off;
hold on;

% Change window size, place in the middle of the screen
% [px, py, length_x, length_y];
% (px=1, py=1) is the bottom left corner
window_width = 600;
window_height = 300;
dimensions = get(0, 'ScreenSize');
screen_width = dimensions(3);
screen_height = dimensions(4);
set(gcf, 'Position', [screen_width/2 - window_width/2, screen_height/2 - window_height/2, window_width, window_height]);

% LED Parameters
% LED Locations and size
% [x, y, radius]
outline_thickness = 7;
led_radius = 0.25;
red_led_position = [1, 1];
green_led_position = [2, 1];
blue_led_position = [3, 1];
% LED operational colors
gui_parameters.red_led_on = [1, 0, 0];
gui_parameters.red_led_off = [0.5, 0, 0];
gui_parameters.green_led_on = [0, 1, 0];
gui_parameters.green_led_off = [0, 0.5, 0];
gui_parameters.blue_led_on = [0, 0, 1];
gui_parameters.blue_led_off = [0, 0, 0.5];

% Draw LEDs as circles in their OFF state (dark colors)
gui_parameters.red_led = rectangle('Position', [red_led_position(1)-led_radius, red_led_position(2) - led_radius, 2*led_radius, 2*led_radius], 'Curvature', [1 1]);
gui_parameters.green_led = rectangle('Position', [green_led_position(1)-led_radius, green_led_position(2) - led_radius, 2*led_radius, 2*led_radius], 'Curvature', [1 1]);
gui_parameters.blue_led = rectangle('Position', [blue_led_position(1)-led_radius, blue_led_position(2) - led_radius, 2*led_radius, 2*led_radius], 'Curvature', [1 1]);
gui_parameters.red_led.LineWidth = outline_thickness;
gui_parameters.red_led.FaceColor = gui_parameters.red_led_off;
gui_parameters.green_led.LineWidth = outline_thickness;
gui_parameters.green_led.FaceColor = gui_parameters.green_led_off;
gui_parameters.blue_led.LineWidth = outline_thickness;
gui_parameters.blue_led.FaceColor = gui_parameters.blue_led_off;

% Assign keypress callback function to figure
set(gui_parameters.gui_figure, 'KeyPressFcn', @(src, event) keyPressCallback(src, event, keypress_pub, keypress_msg));
set(gui_parameters.gui_figure, 'CloseRequestFcn', @closeCallback);


%=========================================================================%
% WRITE YOUR PUBLISHERS AND SUBSCRIBERS HERE
%=========================================================================%
% To-Do
%
% Write a subscriber to the '/keypress' topic. You will need to create a
% subscriber and its corresponding callback function that reads in the data
% from that topic and determine what action you want to perform based on
% the key input.
%
% Write publishers that send a command to the '/red_led', '/green_led',
% and '/blue_led' topics. The message type should be boolean values that
% represent turning the LED ON (true) or OFF (false).


%=========================================================================%
% Main Loop
%=========================================================================%
% Continues looping until the window is exited
while (true)
    pause(0.01);
    
    if (quit_program)
        % Shutdown ROS
        rosshutdown;
        return;
    end
    
    % Keeps the window at the front
    figure(1);
end


%=========================================================================%
% Callback Functions
%=========================================================================%
%===== Subscriber Callbacks =====%
function [] = redLEDCallback(~, msg)
    % Turns the red LED ON if msg contains 'True', OFF if 'False'
    global gui_parameters;
    
    if (msg.Data)
        % Turn red LED ON
        gui_parameters.red_led.FaceColor = gui_parameters.red_led_on;
    else
        % Turn red LED OFF
        gui_parameters.red_led.FaceColor = gui_parameters.red_led_off;
    end
end

function [] = greenLEDCallback(~, msg)
    % Turns the green LED ON if msg contains 'True', OFF if 'False'
    global gui_parameters;

    if (msg.Data)
        % Turn green LED ON
        gui_parameters.green_led.FaceColor = gui_parameters.green_led_on;
    else
        % Turn green LED OFF
        gui_parameters.green_led.FaceColor = gui_parameters.green_led_off;
    end
end

function [] = blueLEDCallback(~, msg)
    % Turns the blue LED ON if msg contains 'True', OFF if 'False'
    global gui_parameters;

    if (msg.Data)
        % Turn blue LED ON
        gui_parameters.blue_led.FaceColor = gui_parameters.blue_led_on;
    else    
        % Turn blue LED OFF
        gui_parameters.blue_led.FaceColor = gui_parameters.blue_led_off;
    end
end
%================================%

%===== GUI Callback Functions =====%
function [] = keyPressCallback(src, event, keypress_pub, keypress_msg)
    % Publish the key pressed on '/keypress' topic
    keypress_msg.Data = uint8(event.Character);
    send(keypress_pub, keypress_msg);
end

function [] = closeCallback(src, callbackdata)
    % Delete the figure
    delete(gcf);
    % Exit the program
    global quit_program;
    quit_program = true;
end
%==================================%