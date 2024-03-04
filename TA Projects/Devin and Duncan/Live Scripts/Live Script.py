import numpy as np
import matplotlib.pyplot as plt

import matplotlib as mpl

mpl.rcParams.update({"font.size": 20, "font.family": "Palatino Linotype"})


y_label_post_and_pre = "Programming\nConfidence (%)"
y_label_post_minus_pre = "Improvement"
x_ticks_label = ["Pre\nRepro", "Post\nRepro"]

color_pre = [0.1373, 0.3255, 0.4980]
color_post = [0.5961, 0.3098, 0.8706]
color_post_minus_pre = [0.9686, 0.4039, 0]

colors = [color_pre, color_post]

box_plot_width = .75
jitter_plot_width = box_plot_width / 3

# generate data
n_learners = 53
n_groups = 2
pre_low = 0
pre_high = 55
post_low = 75
post_high = 100

def generate_pre_post_data(n_learners, pre_params, post_params):
    pre_data = np.random.uniform(pre_params[0], pre_params[1], size= n_learners)
    post_data = np.random.uniform(post_params[0], post_params[1], size = n_learners)
    data =  [pre_data, post_data]
    return data

data_pre_post = generate_pre_post_data(n_learners=n_learners, 
                                       pre_params= [pre_low, pre_high],
                                       post_params= [post_low, post_high])

data_post_minus_pre = data_pre_post[1] - data_pre_post[0]

# create figure
fig = plt.figure()

subplot_row = 1
subplot_col = 3

ax_pre_post = plt.subplot2grid((subplot_row, subplot_col), loc= (0,0), colspan= 2)
ax_post_minus_pre = plt.subplot2grid((subplot_row, subplot_col), loc= (0,2))

# boxplots pre and post
boxplot_pre_post = ax_pre_post.boxplot(x = data_pre_post, patch_artist=True, widths= box_plot_width)

for box, color_code, median in zip(boxplot_pre_post["boxes"], colors, boxplot_pre_post["medians"]):
    box.set_facecolor(color_code)
    box.set_alpha(0.5)
    median.set_color('black')
    
# boxplots post minus pre
boxplot_post_minus_pre = ax_post_minus_pre.boxplot(x= data_post_minus_pre, patch_artist=True, widths= box_plot_width)

boxplot_post_minus_pre["boxes"][0].set_facecolor(color_post_minus_pre)
boxplot_post_minus_pre["boxes"][0].set_alpha(0.5)
boxplot_post_minus_pre["medians"][0].set_color("black")

# scatter plots post and pre
for idx in range(n_groups):
    x_data = np.ones((1, n_learners)) + idx
    x_jittered_data = x_data+ np.random.uniform(low= -jitter_plot_width,
                                                high = jitter_plot_width,
                                                size = n_learners)
    ax_pre_post.scatter(x= x_jittered_data, 
                        y = data_pre_post[idx], 
                        color = colors[idx], 
                        zorder = 10,
                        s = 50,
                        edgecolor = 'black')
    
# scatter plots post minus pre

x_data = np.ones((1,n_learners))
x_jittered_data = x_data + np.random.uniform(low= -jitter_plot_width, high= jitter_plot_width, size = n_learners)
ax_post_minus_pre.scatter(x = x_jittered_data,
                          y = data_post_minus_pre,
                          color = color_post_minus_pre,
                          zorder = 10,
                          s = 50,
                          edgecolor = 'black')

# fine tune our figure
## post and pre comparison
ax_pre_post.set_ylabel(y_label_post_and_pre)
ax_pre_post.set_xticklabels(x_ticks_label)

ax_post_minus_pre.set_ylabel(y_label_post_minus_pre)

## post MINUS pre
ax_post_minus_pre.set_xticks([])

ax_post_minus_pre.set_ylim(20, 100)


chopped_y_tick_labels = [t._text for t in ax_post_minus_pre.get_yticklabels()[1:-1]]

new_y_tick_labels = ["Less"] + chopped_y_tick_labels + ["More"]
y_tick_vales = [v._y for v in ax_post_minus_pre.get_yticklabels()]

ax_post_minus_pre.set_yticks(ticks = y_tick_vales, labels= new_y_tick_labels)


# show fig

ax_pre_post.grid(alpha = .5)
ax_pre_post.spines[["top", "right"]].set_visible(False)

ax_post_minus_pre.grid(alpha = .5)
ax_post_minus_pre.spines[["top", "right"]].set_visible(False)

plt.tight_layout()
plt.show()