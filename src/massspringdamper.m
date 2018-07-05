%% MASS-SPRING-DAMPER ANIMATION

% -----------------------------------
% Ideal MASS-SPRING-DAMPER Model animation.
% Author: Gabriele Serra (gabriele_serra@hotmail.it)
% License: MIT
% -----------------------------------

%% ANIMATION/FIGURE INIT

% x is the variable that contains output of the simulation
% dataLen will contain the number of simulation samples
dataLen = size(x.Time, 1);

% prepare figure environment
figure(1);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.15, 0.35, 0.85, 0.65]);

% let's create the 2D figure subplot
subplot(1, 2, 1);

% limit axis
xlim([0 x.Time(dataLen)]);
ylim([-0.5 2]);

% hold and enable grid
grid on;
hold on;

% let's create the 3D animation figure subplot
figure(1);
subplot(1, 2, 2);

% limit axis
view(3);
xlim([0 2]);
ylim([-1 1]);
zlim([0 0.5]);

% hold and enable grid
grid on;
hold on;

%% SPRING POSITION
% spring left-right position over time (LX: constant- RX: variable)
sPosX = [0 x.Data(1) + 1];
sPosY = [0 0];
sPosZ = [0.1 0.1];

%% MASS POSITION
% 8 cube vertexes position
% left-front-lower  -> 1
% right-front-lower -> 2
% right-back-lower  -> 6
% left-back-lower   -> 5

% left-front-upper  -> 7
% right-front-upper -> 3
% right-back-upper  -> 4
% left-back-upper   -> 8
    
mPosX = [0.75 1.25 1.25 0.75 0.75 1.25 1.25 0.75]';
mPosY = [-0.25 -0.25 0.25 0.25 -0.25 -0.25 0.25 0.25]';
mPosZ = [0.01 0.01 0.01 0.01 0.2 0.2 0.2 0.2]';

mVertex = [mPosX mPosY mPosZ];
mFaces = [1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8];


%% FLOOR POSITION
[fPosX, fPosY] = meshgrid(0:2,-1:1);
fPosZ = zeros(size(fPosX,1), size(fPosY,1));

%% STEP RESPONSE
stepX = x.Time(1);
stepY = x.Data(1);

%% DRAW ONTO FIGURE IN PSEUDO-REAL-TIME

% plot the floor surface
surf(fPosX, fPosY, fPosZ, fPosZ, 'FaceColor', 'interp');

% plot spring
spring = plot3(sPosX, sPosY, sPosZ, '-k', 'LineWidth', 3);
spring.XDataSource = 'sPosX';
spring.YDataSource = 'sPosY';
spring.ZDataSource = 'sPosZ';

% plot mass
mass = patch('Vertices', mVertex, 'Faces', mFaces, 'FaceAlpha', 0.2);

% plot step response
figure(1);
subplot(1, 2, 1);
plot(stepX, stepY, '-ko');

for k = 2:dataLen    
    % calculate time difference and wait
    t_k_diff = x.Time(k) - x.Time(k-1);
    pause(t_k_diff);
     
    % update mass position
    mPosX = [x.Data(k) + 0.75;
             x.Data(k) + 1.25;
             x.Data(k) + 1.25;
             x.Data(k) + 0.75;
             x.Data(k) + 0.75;
             x.Data(k) + 1.25;
             x.Data(k) + 1.25;
             x.Data(k) + 0.75];
    mVertex = [mPosX mPosY mPosZ];

    % update spring position
    sPosX = [0 x.Data(k) + 1];
    
    % update step response
    stepX = x.Time(k);
    stepY = x.Data(k);
    
    % 3d update
    figure(1);
    subplot(1, 2, 2);

    % delete mass graphic data
    massPlot = get(gca, 'children');
    delete(massPlot(1));
    
    % refresh spring graphic data
    refreshdata;
    
    % print new mass graphic data
    patch('Vertices', mVertex, 'Faces', mFaces, 'FaceAlpha', 0.2);
    
    % 2d update
    figure(1);
    subplot(1, 2, 1);
    plot(stepX, stepY, '-ko');
end

fprintf("Simulation finished.\n");