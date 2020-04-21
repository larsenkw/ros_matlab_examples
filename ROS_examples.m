% This code lists out example syntax for how to code using ROS in Matlab
%
%   Author: Kyle Larsen
%   Date: 30 Mar 2020


%=========================================================================%
% General ROS Commands
%=========================================================================%
% These are the commands run in the command window and are not used in a
% script.
%
% rosinit
%   Connects the current Matlab instance with the ROS master. If there is
%   no ROS master already running, it will start one. This must be run once
%   for each Matlab window that is opened and needs to communicate with
%   ROS. If 'rosinit' has already been run in a window, when you run
%   'rosinit' again, it will throw an error.
%
%   Example
%   >> rosinit
%
% rostopic list
%   Lists all of the currently available topics that can be published or
%   subscribed to.
%
%   Example
%   >> rostopic list
%
% rostopic echo /[topic_name]
%   Prints out the messages from [topic_name] to the command window as they
%   are published. Use 'Ctrl + c' to exit this command.
%
%   Example
%   >> rostopic echo /keypress
%
% rosshutdown
%   Closes the connection to ROS in the current Matlab instance.
%
%   Example
%   >> rosshutdown
%=========================================================================%
% Using a 'try/catch' statement avoids running 'rosinit' if it is already
% running.
try
    rosinit;
catch
end


%=========================================================================%
% Publishers
%=========================================================================%
% First, you will need to create a message object. This object contains the
% variables that will be sent on the topic by the publisher.
%
% 'rosmessage(messagetype)'
%   https://www.mathworks.com/help/ros/ref/rosmessage.html
%
% To see a list of available ROS message types use: rosmsg list
%
%   Example
%   >> rosmsg list
%
% To see the structure of a message type use: rosmsg show [message_type]
%
%   Example
%   >> rosmsg show geometry_msgs/Twist
%
% ROS Message Tutorial
%   https://www.mathworks.com/help/ros/ug/work-with-basic-ros-messages.html
int16_msg = rosmessage('std_msgs/Int16');
point_msg = rosmessage('geometry_msgs/Point');
twist_msg = rosmessage('geometry_msgs/Twist');

% Then you can create the publisher specifying the message type to tell the
% publisher what type of data will be sent on the topic. The second
% parameter, 'msgtype', must match the message object type that will be
% sent on the topic by the publisher.
%
% 'rospublisher(topicname, messagetype)'
%   https://www.mathworks.com/help/ros/ref/publisher.html#d120e20626
int16_pub = rospublisher('/int16_topic', 'std_msgs/Int16');
point_pub = rospublisher('/point_topic', 'geometry_msgs/Point');
twist_pub = rospublisher('/twist_topic', 'geometry_msgs/Twist');

% Once the publisher is created you can then send messages on through it.
% But first, remember to define the message data.
int16_msg.Data = 27;
point_msg.X = 11;
point_msg.Y = 34.7;
point_msg.Z = 28.976;
twist_msg.Linear.X = 10;
twist_msg.Angular.Z = 0.5;

int16_pub.send(int16_msg);
point_pub.send(point_msg);
twist_pub.send(twist_msg);
%=========================================================================%


%=========================================================================%
% Subscribers
%=========================================================================%
% Subscribers use 'callback' functions to receive and process the messages
% from a topic. Creating the subscriber creates a connection to the topic
% which is always listening for when a publisher sends data across the
% topic. When a message is published, the subscriber will receive the data
% and pass it into the callback function. Use the '@' symbol before a
% function name to pass it as a function handle. This allows the function
% to be passed to another function as a "parameter".
%
% 'rossubscriber(topicname, messagetype, callback)'
%   https://www.mathworks.com/help/ros/ref/subscriber.html
int16_sub = rossubscriber('/int16_topic', 'std_msgs/Int16', @int16Callback);
point_sub = rossubscriber('/point_topic', 'geometry_msgs/Point', @pointCallback);
twist_sub = rossubscriber('/twist_topic', 'geometry_msgs/Twist', @twistCallback);

for i = 1:1
    int16_pub.send(int16_msg);
    point_pub.send(point_msg);
    twist_pub.send(twist_msg);
    pause(1);
end
%=========================================================================%


%=========================================================================%
% Subscriber Callback Functions
%=========================================================================%
% The first argument in the callback is the subscriber object. We care
% about the message so the '~' placeholder is used to essentially ignore
% that parameter.
%
% callbackFunction(sub, msg);
%   https://www.mathworks.com/help/ros/ug/exchange-data-with-ros-publishers-and-subscribers.html#ExchangeDataWithROSPublishersAndSubscribersExample-2
function [] = int16Callback(~, msg)
    % Do something with 'msg' in here
    disp(msg);
end

function [] = pointCallback(~, msg)
    % Do something with 'msg' in here
    fprintf('The X position: %0.2f\n', msg.X);
end

function [] = twistCallback(~, msg)
    % Do something with 'msg' in here
    fprintf('Linear Velocity: %0.2f\nAngular Velocity: %0.2f\n', ...
            msg.Linear.X, msg.Angular.Z);
end
%=========================================================================%