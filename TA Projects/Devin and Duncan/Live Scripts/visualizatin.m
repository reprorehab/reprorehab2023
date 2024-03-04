%% Visualizations

clear();
clc();
close('all');

code_folder = ['/Users/duncan/Documents/GitHub/reprorehab2023_TA_project' ...
  '/TA Projects/Devin and Duncan/Live Scripts'];

cd(code_folder);

%% Simulate data 

N_LEARNERS = 53;
LOW_PRE = 0;
HIGH_PRE = 55; 
LOW_POST = 75;
HIGH_POST = 100;

data_pre = generateUniformRandom(LOW_PRE, HIGH_PRE, [1, N_LEARNERS]);
data_post = generateUniformRandom(LOW_POST, HIGH_POST, [1, N_LEARNERS]);

RGB_PRE = [0.1373, 0.3255, 0.4980];
RGB_POST = [0.5961, 0.3098, 0.8706];
RGB_IMPROVEMENT = [0.9686, 0.4039, 0];

%% Visualize 

figure();
ax_pre_and_post = subplot(1, 3, 1:2);

plot_box_with_data(ax_pre_and_post, 1, data_pre, RGB_PRE);
plot_box_with_data(ax_pre_and_post, 2, data_post, RGB_POST);

grid(ax_pre_and_post, 'on'); 
xticks(ax_pre_and_post, 1:2);
xticklabels(ax_pre_and_post, {'Pre-RR', 'Post-RR'});
ylabel(ax_pre_and_post, 'Programming Confidence (%)');

ax_post_minus_pre = subplot(1, 3, 3);
plot_box_with_data(ax_post_minus_pre, 1, data_post - data_pre, ...
  RGB_IMPROVEMENT);
xticks(ax_post_minus_pre, []);
set(ax_post_minus_pre, 'YTickLabel', ...
  [{'Less'}; ax_post_minus_pre.YTickLabel(2:end-1); {'More'}]);
ylabel(ax_post_minus_pre, 'Improvement');
grid(ax_post_minus_pre, 'on');

%% Local functions

function plot_box_with_data(ax, x_value, y_values, color)

n_values = length(y_values);
boxchart(ax, repelem(x_value, n_values), y_values, ...
  "BoxFaceColor", color);
hold(ax, 'on');
swarmchart(ax, repelem(x_value, n_values), y_values, ...
  'MarkerFacecolor', color, ...
  'SizeData', 75, ...
  'MarkerEdgeColor', 'black', ...
  'xjitter', 'density', ...
  'XJitterWidth', 0.5);

end

function data = generateUniformRandom(low, high, size)
data = low + (high - low) .* rand(size);
end
