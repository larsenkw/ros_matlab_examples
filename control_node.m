% control_node: Example ROS Node for controlling the LEDs
%
% Follow the outline below to create your node for controlling the LEDs in
% the "example_ROS_LED.m" script.
%
% Notes
%------------
%   You should run the the "example_ROS_LED.m" script before running this
%   code.
%
%   Be aware that if you close out of "example_ROS_LED.m" after running
%   this file, you will need to run "rosshutdown" in the command window
%   before rerunning this script.
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
% HINT: you will want to declare the messages and publishers as "global"
% variables so that they can be used in the callback functions.
%
% Example
% global red_msg red_pub 
% red_msg = rosmessage('std_msgs/Bool');
% red_pub = rospublisher('/red_led', 'std_msgs/Bool');
%
% Another option would be to create a "struct" that contains the messages
% and publishers and then you pass that parameter to your callback function
% handle.
%
% Example
% led_struct = struct;
% led_struct.red_msg = rosmessage('std_msgs/Bool');
% led_struct.red_pub = rospublisher('/red_led', 'std_msgs/Bool');
% 
% Callback function
% function [] = callback(led_struct, sub, msg)
% ... (function content)
% end
%
% Subscriber
% sub = rossubscriber('/topic_name', 'messagetype', @(sub, msg) ...
%                     callback(led_struct, sub, msg));
% "sub" and "msg" will still be unknown variables, but "led_struct" will be
% passed into the function using the variable defined above.

% YOUR PUBLISHERS HERE

%=========================================================================%
% Subscribers
%=========================================================================%
% Create Subscriber for the keyboard keypress

% YOUR SUBSCRIBERS HERE

%=========================================================================%
% Callback Functions
%=========================================================================%
% Functions in a Matlab script must be defined at the end of the script.

% YOUR CALLBACK FUNCTIONS HERE
