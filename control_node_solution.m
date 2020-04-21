% control_node_solution: Example ROS Node for controlling the LEDs
%
% This is an example solution script for controlling the LEDs from the
% "example_ROS_LED.m" script. Your solution will probably be different.
% Feel free to use this as a guide for any parts where you may get stuck.
%
% ROS Topics
%------------
%   Published Topics
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
%   Subscribed Topics
%   /keypress
%   Message Type: std_msgs/Char
%   Info: ASCII number of the key pressed by the keyboard, 'r' = 114, 
%   'g' = 103, 'b' = 98
%
%   Author: Kyle Larsen
%   Date: 30 Mar 2020

%=========================================================================%
% Initialize ROS
%=========================================================================%
try
    rosinit;
catch
end


%=========================================================================%
% Publishers
%=========================================================================%
% Create Publishers to turn ON or OFF the LEDs
led_msgs = struct;
led_pubs = struct;
led_msgs.red_msg = rosmessage('std_msgs/Bool');
led_msgs.green_msg = rosmessage('std_msgs/Bool');
led_msgs.blue_msg = rosmessage('std_msgs/Bool');
led_msgs.red_msg.Data = true;
led_msgs.green_msg.Data = true;
led_msgs.blue_msg.Data = true;
led_pubs.red_pub = rospublisher('/red_led', 'std_msgs/Bool');
led_pubs.green_pub = rospublisher('/green_led', 'std_msgs/Bool');
led_pubs.blue_pub = rospublisher('/blue_led', 'std_msgs/Bool');


%=========================================================================%
% Subscribers
%=========================================================================%
% Create Subscriber for the keyboard keypress
keypress_sub = rossubscriber('/keypress', 'std_msgs/Char', @(sub, msg) keypressCallback(led_msgs, led_pubs, sub, msg));


%=========================================================================%
% Callback Functions
%=========================================================================%
% Functions in a Matlab script must be defined at the end of the script.

% Subscriber Callback Function
function [] = keypressCallback(led_msgs, led_pubs, ~, msg)
    % 'r' Key = 114
    if (msg.Data == 114)
        led_pubs.red_pub.send(led_msgs.red_msg);
        
        % Switch ON/OFF
        led_msgs.red_msg.Data = ~led_msgs.red_msg.Data;
    end
    
    % 'g' Key = 103
    if (msg.Data == 103)
        led_pubs.green_pub.send(led_msgs.green_msg);
        
        % Switch ON/OFF
        led_msgs.green_msg.Data = ~led_msgs.green_msg.Data;
    end
    
    % 'b' Key = 98
    if (msg.Data == 98)
        led_pubs.blue_pub.send(led_msgs.blue_msg);
        
        % Switch ON/OFF
        led_msgs.blue_msg.Data = ~led_msgs.blue_msg.Data;
    end
end

