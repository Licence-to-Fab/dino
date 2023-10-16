load('comparison_data.mat');
close all

%some variables for data scaling
GR = 3.2; %unitless
r_wheel = 0.313; %meters
m_s_to_kph = 3.6; %1m/s = 3.6kph
scaling_factor_rpm_kph = 2*pi/60/GR*r_wheel*3.6;

%time scaling by looking at graphs
batt_run_time_sync_factor = (26.448-12.3976)+(21.7179-19.85); %time to subtract from SEVCON to sync to Dyno

batt_run_dyno_time_processed = batt_run_dyno_time;
batt_run_sevcon_time_processed = batt_run_time-batt_run_time_sync_factor;

%more complex time sync factors
fc_run_p1_sevcon_dyno_ts = (18.2687-15.2); %syncs part 1 dyno to part 1 sevcon
fc_run_p2_sevcon_dyno_ts = (111.532-92.3); %syncs part 2 dyno to part 2 sevcon
mutual_scale = 610.0; %shifts up time to "append" data

%now process battery and FC data --> time syncing matrix?
fc_run_dyno_time_combined = [fc_run_dyno_time_P1;fc_run_dyno_time_P2+mutual_scale];
fc_run_sevcon_time_combined = [fc_run_times_P1-fc_run_p1_sevcon_dyno_ts;fc_run_times_P2+mutual_scale-fc_run_p2_sevcon_dyno_ts];

fc_run_dyno_speed_combined = [fc_run_dyno_speed_kph_P1;fc_run_dyno_speed_kph_P2];
fc_run_sevcon_RPM_combined = [fc_run_motor_RPM_P1;fc_run_motor_RPM_P2];

fc_run_motor_torque_combined = [fc_run_motor_torque_P1;fc_run_motor_torque_P2];
fc_run_batt_voltage_combined = [fc_run_batt_voltage_P1;fc_run_batt_voltage_P2];
fc_run_batt_current_combined = [fc_run_batt_current_P1;fc_run_batt_current_P2];

%plot cross datasets