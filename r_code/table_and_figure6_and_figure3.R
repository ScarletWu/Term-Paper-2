library(haven)
library(dplyr)
library(ggplot2)
library(readr)
library(here)
library(janitor)
library(knitr)
library(kableExtra)


# Read the dataset
main_clean <- read_dta(here("inputs/data/clean_data/01_main_exp_clean.dta"))
follow_up_clean <- read_dta(here("inputs/data/clean_data/02_follow_up_clean.dta"))
online_survey_clean <- read_dta(here("inputs/data/clean_data/original03_1st_online_svy_clean.dta"))


# Test
main_clean$condition2 |> unique()


# Observations
total_rows <- nrow(main_clean)
c_rows <- sum(main_clean$condition2 == 0, na.rm = TRUE)
t_rows <- sum(main_clean$condition2 == 1, na.rm = TRUE)

# Age
total_age <- round(mean(main_clean$age, na.rm = TRUE), 2)
c_age <- round(mean(main_clean$age[main_clean$condition2 == 0], na.rm = TRUE), 2)
t_age <- round(mean(main_clean$age[main_clean$condition2 == 1], na.rm = TRUE), 2)
# Age standard deviation
total_age_sd <- paste0("(", round(sd(main_clean$age, na.rm = TRUE), 2), ")")
c_age_sd <- paste0("(", round(sd(main_clean$age[main_clean$condition2 == 0], na.rm = TRUE), 2), ")")
t_age_sd <- paste0("(", round(sd(main_clean$age[main_clean$condition2 == 1], na.rm = TRUE), 2), ")")


# Number of children
total_ch <- round(mean(main_clean$children, na.rm = TRUE), 2)
c_ch <- round(mean(main_clean$children[main_clean$condition2 == 0], na.rm = TRUE), 2)
t_ch <- round(mean(main_clean$children[main_clean$condition2 == 1], na.rm = TRUE), 2)
# Number of children standard deviation
total_ch_sd <- paste0("(", round(sd(main_clean$children, na.rm = TRUE), 2), ")")
c_ch_sd <- paste0("(", round(sd(main_clean$children[main_clean$condition2 == 0], na.rm = TRUE), 2), ")")
t_ch_sd <- paste0("(", round(sd(main_clean$children[main_clean$condition2 == 1], na.rm = TRUE), 2), ")")


# College Degree (%)
total_cd <- round(mean(main_clean$college_deg == 1, na.rm = TRUE) * 100, 2)
c_cd <- main_clean |> filter(condition2 == 0) |>
  summarise(c_cd = round(mean(college_deg == 1, na.rm = TRUE) * 100, 2)) |> pull(c_cd)
t_cd <- main_clean |> filter(condition2 == 1) |>
  summarise(t_cd = round(mean(college_deg == 1, na.rm = TRUE) * 100, 2)) |> pull(t_cd)


# Employed (%)
total_emp <- round((sum(main_clean$employed_now == 1, na.rm = TRUE) / total_rows) * 100, 2)
c_emp <- main_clean %>%
  filter(condition2 == 0) %>%
  summarise(c_emp = round(sum(employed_now == 1, na.rm = TRUE) / c_rows * 100, 2)) %>%
  pull(c_emp)
t_emp <- main_clean %>%
  filter(condition2 == 1) %>%
  summarise(t_emp = round(sum(employed_now == 1, na.rm = TRUE) / t_rows * 100, 2)) %>%
  pull(t_emp)


# Wife employed (%)
total_we <- round((sum(main_clean$employed_wife == 1, na.rm = TRUE) / total_rows) * 100, 2)
c_we <- main_clean %>%
  filter(condition2 == 0) %>%
  summarise(c_we = round(sum(employed_wife == 1, na.rm = TRUE) / c_rows * 100, 2)) %>%
  pull(c_we)
t_we <- main_clean %>%
  filter(condition2 == 1) %>%
  summarise(t_we = round(sum(employed_wife == 1, na.rm = TRUE) / t_rows * 100, 2)) %>%
  pull(t_we)


# Wife working outside the home (% retrospective follow-up)
c_wo <- follow_up_clean %>%
  filter(condition2 == 0) %>%
  filter(matched == 1) %>%
  summarise(c_wo = round(mean(employed_3mos_out_fl) * 100, 2)) %>%
  pull(c_wo)
t_wo <- follow_up_clean %>%
  filter(condition2 == 1) %>%
  filter(matched == 1) %>%
  summarise(t_wo = round(mean(employed_3mos_out_fl) * 100, 2)) %>%
  pull(t_wo)
total_wo <- follow_up_clean %>%
  filter(matched == 1) %>%
  summarise(total_wo = round(mean(employed_3mos_out_fl) * 100, 2)) %>%
  pull(total_wo)


# Other participants known (%)
total_kn <- round(mean(main_clean$num_know_per, na.rm = TRUE) * 100, 2)
c_kn <- main_clean %>%
  filter(condition2 == 0) %>%
  summarise(c_kn = round(mean(num_know_per, na.rm = TRUE) * 100, 2)) %>%
  pull(c_kn)
t_kn <- main_clean %>%
  filter(condition2 == 1) %>%
  summarise(t_kn = round(mean(num_know_per, na.rm = TRUE) * 100, 2)) %>%
  pull(t_kn)
# Other participants known standard deviation (%)
total_kn_sd <- paste0("(", round(sd(main_clean$num_know_per, na.rm = TRUE) * 100, 2), ")")
c_kn_sd <- paste0("(", round(sd(main_clean$num_know_per[main_clean$condition2 == 0], na.rm = TRUE) * 100, 2), ")")
t_kn_sd <- paste0("(", round(sd(main_clean$num_know_per[main_clean$condition2 == 1], na.rm = TRUE) * 100, 2), ")")

# Other participants with mutual friends (%)
total_mf <- round(mean(main_clean$num_mfs_per, na.rm = TRUE) * 100, 2)
c_mf <- main_clean %>%
  filter(condition2 == 0) %>%
  summarise(c_mf = round(mean(num_mfs_per, na.rm = TRUE) * 100, 2)) %>%
  pull(c_mf)
t_mf <- main_clean %>%
  filter(condition2 == 1) %>%
  summarise(t_mf = round(mean(num_mfs_per, na.rm = TRUE) * 100, 2)) %>%
  pull(t_mf)
# Other participants with mutual friends standard deviation (%)
total_mf_sd <- paste0("(", round(sd(main_clean$num_mfs_per, na.rm = TRUE) * 100, 2), ")")
c_mf_sd <- paste0("(", round(sd(main_clean$num_mfs_per[main_clean$condition2 == 0], na.rm = TRUE) * 100, 2), ")")
t_mf_sd <- paste0("(", round(sd(main_clean$num_mfs_per[main_clean$condition2 == 1], na.rm = TRUE) * 100, 2), ")")



# Assign groups
total_group <- c(total_rows, total_age, total_age_sd, total_ch, total_ch_sd, total_cd, total_emp, total_we, total_wo, total_kn, total_kn_sd, total_mf, total_mf_sd)
control_group <- c(c_rows, c_age, c_age_sd, c_ch, c_ch_sd, c_cd, c_emp, c_we, c_wo, c_kn,c_kn_sd, c_mf, c_mf_sd)
treatment_group <- c(t_rows, t_age, t_age_sd, t_ch, t_ch_sd, t_cd, t_emp, t_we, t_wo, t_kn, t_kn_sd, t_mf, t_mf_sd)



table1 <- cbind(total_group, control_group, treatment_group)
row.names(table1)= c("Observations","Age","","Number of Children","","College Degree (%)","Employed (%)","Wife Employed (%)", "Wife Working Outside the Home (% retrospective follow-up)", "Other Participants Known (%)", "","Other Participants with Mutual Friends (%)","")

table1 |> kbl(booktabs = T, col.names = c("All","Control","Treatment"), align=rep('c', 4)) |> 
  row_spec(1, hline_after = TRUE) |> kable_styling()

write.csv(table1, file = "/cloud/project/outputs/table/table1.csv", row.names = FALSE)


# Figure 3
p_value_figure3 <- chisq.test(table(main_clean$condition2, main_clean$signed_up_number))
percentage_data_figure3 <- main_clean |>
  mutate(condition2 = ifelse(condition2 == 0, 'Control', 'Treatment')) |>
  group_by(condition2) |>
  summarise(percentage = mean(signed_up_number == 1) * 100)

plot_figure3 <- ggplot(percentage_data_figure3, aes(x = condition2, y = percentage)) +
  geom_bar(stat = "identity", fill = "grey", color = "black", alpha = 0.9) +
  labs(x = "",
       y = "Percent sign up") +
  geom_text(aes(label = paste0(round(percentage, 2), "%")),
            position = position_dodge(width = 0.9),
            vjust = -0.5) +
  annotate("text", x = 1.5, y = 37, label = sprintf("p-value = %.4f", p_value_figure3$p.value)) +
  theme_minimal() + 
  ylim(0, 40)
ggsave("/cloud/project/outputs/figures/figure3.png", plot = plot_figure3)


# Figure 6
outside_value <- na.omit(online_survey_clean$c_outside_guess_frac)
group <- rep("Control", length(outside_value))
c_outside <- cbind(outside_value, group)
c_outside <- data.frame(c_outside)

outside_value <- na.omit(online_survey_clean$t_outside_guess_frac)
group <- rep("Treatment", length(outside_value))
t_outside <- cbind(outside_value, group)
t_outside <- data.frame(t_outside)
data_frame <- rbind(c_outside, t_outside)

c_mean <- mean(online_survey_clean$c_outside_mean)/100
t_mean <- mean(online_survey_clean$t_outside_mean)/100

data_frame <- data.frame(data_frame)
data_frame$group <- as.factor(data_frame$group)
data_frame$outside_value <- as.numeric(data_frame$outside_value)


figure6 <-
  data_frame |>
  ggplot(aes(x = outside_value)) +
  theme_minimal() +
  stat_ecdf(aes(color = group, linetype = group), linewidth = 0.5) +
  scale_y_continuous(name = "Cumulative Probability", breaks = c(0,.2,.4,.6,.8,1), limits = c(0,1)) +
  scale_x_continuous(name = "Share of other agreeing", breaks = c(0,.2,.4,.6,.8,1), limits = c(0,1)) +
  theme(legend.position = "bottom", legend.title = element_blank(),
        legend.direction = "vertical",
        aspect.ratio = 0.5,
        legend.box.background = element_rect(color = "black", linewidth = 0.5)) +
  scale_linetype_discrete(labels = c("Control (perceptions about others' answers)", "Treatment (Perception about others' beliefs)")) +
  scale_colour_manual(values = c("black","tomato4"), labels = c("Control (perceptions about others' answers)", "Treatment (Perception about others' beliefs)")) +
  geom_vline(aes(xintercept = c_mean), col = "black")+
  geom_vline(aes(xintercept = t_mean), col="tomato4", linetype ="longdash") +
  annotate(geom = "text",
           label = c("True proportion\n(treatment)","True proportion\n(control)"),
           x = c(0.8, 1),
           y = 0.15,
           vjust = -1,
           hjust = 1,
           size = 2,
           col = c("black","black"))

ggsave("/cloud/project/outputs/figures/figure6.png", plot = figure6)

