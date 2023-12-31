clear all
close all

load('comparison_data.mat');

%some variables for data scaling
GR = 3.2; %unitless
r_wheel = 0.313; %meters
m_s_to_kph = 3.6; %1m/s = 3.6kph
scaling_factor_rpm_kph = 2*pi/60/GR*r_wheel*m_s_to_kph;

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

%fuel cell timing factors
fc_logging_rate = 2.0; %Hz
fc_time_P1 = 0.0:(1/fc_logging_rate):(1/fc_logging_rate)*(length(fc_run_fc_temp_P1)-1);
fc_time_P2 = 0.0:(1/fc_logging_rate):(1/fc_logging_rate)*(length(fc_run_fc_temp_P2)-1);
fc_run_fc_sevcon_time_shift_P1 = 124.5-7.5;
fc_run_fc_sevcon_time_shift_P2 = (124.5-7.5)+(655.5-641.0)-(1290-1277);

fc_run_fc_time_combined = [fc_time_P1'-fc_run_fc_sevcon_time_shift_P1;fc_time_P2'-fc_run_fc_sevcon_time_shift_P2+mutual_scale];

fc_run_output_current_combined = [fc_run_fc_output_current_P1;fc_run_fc_output_current_P2];
fc_run_output_voltage_combined = [fc_run_fc_output_voltage_P1;fc_run_fc_output_voltage_P2];
fc_run_stack_current_combined = [fc_run_stack_current_P1;fc_run_stack_current_P2];
fc_run_stack_voltage_combined = [fc_run_stack_voltage_P1;fc_run_stack_voltage_P2];
fc_run_tank_pressure_combined = [fc_run_H2_pressure_P1;fc_run_H2_pressure_P2];

%plot cross datasets
%plot battery voltage for both runs
figure;
grid on
hold on
plot(batt_run_sevcon_time_processed,batt_run_batt_voltage)
plot(fc_run_sevcon_time_combined,fc_run_batt_voltage_combined)
xline(630) %based on shifting the measured error time
xlim([0,1308])
title('Battery Voltage vs. Time — 5 Runs of MTDC')
xlabel('Time (s)')
ylabel('Battery Voltage (V)')
legend('Battery Only','Battery and Fuel Cell','Overcurrent Fault')

%plot tank pressure for both runs
figure;
grid on
hold on
yyaxis left
plot(fc_run_fc_time_combined,fc_run_tank_pressure_combined)
xline(630)
title('H2 Tank Pressure vs. Time')
xlabel('Time (s)')
ylabel('Tank Pressure (bar)')

%calculate the 'energy' of H2 used (or mass in kg used)
R = 1/12.027235504273; %p is in bar, V is in L, T is in K
V = 7.0; %7L tank
T = 293.0; %kelvin
mol_to_kg_H2 = 2.02*10^(-3);
energy_kg_H2 = 33.33; %33.33 kWh/kg

mass_h2_P1 = [];
for i=1:1:length(fc_run_H2_pressure_P1)
    P = fc_run_H2_pressure_P1(i);
    n = P*V/R/T;
    mass_h2_P1 = [mass_h2_P1;n*mol_to_kg_H2];
end

mass_h2_P2 = [];
for i=1:1:length(fc_run_H2_pressure_P2)
    P = fc_run_H2_pressure_P2(i);
    n = P*V/R/T;
    mass_h2_P2 = [mass_h2_P2;n*mol_to_kg_H2];
end

mass_H2_combined = [mass_h2_P1;mass_h2_P2]-mass_h2_P1(2);
mass_H2_combined = mass_H2_combined.*-energy_kg_H2;

yyaxis right
plot(fc_run_fc_time_combined,mass_H2_combined)
ylabel('Energy H2 Used (kWh)')
legend('H2 Tank Pressure','Overcurrent Fault','Energy H2')

%miles driven calculation
total_distance = trapz(batt_run_dyno_time_processed./3600,batt_run_dyno_speed_kph);

figure;
plot(batt_run_dyno_time_processed./3600,batt_run_dyno_speed_kph)
grid on
title("(5x) MTDC Drive Cycle, Distance: " + num2str(total_distance) + " km")
xlabel('Time (h)')
ylabel('Velocity in (kph)')

%motor power during a drive cycle
rpm_to_rps = 2*pi/60;
batt_run_motor_rps = batt_run_motor_RPM.*rpm_to_rps;
batt_run_motor_power = batt_run_motor_rps.*batt_run_torques;
batt_run_motor_power = batt_run_motor_power./1000.0;
avg_pwr = mean(rmmissing(batt_run_motor_power));

figure;
plot(batt_run_sevcon_time_processed,batt_run_motor_power)
yline(avg_pwr)
grid on
xlim([0,1200])
title("Motor Power vs. Time on Drive Cycle")
xlabel('Time (s)')
ylabel('Power (kW)')
legend('Motor Power',"Average Motor Power: " + num2str(avg_pwr) + " kW")

%add an acceleration graph (DO WITH MOTOR RPM
batt_run_ms = batt_run_motor_rps./(GR/r_wheel);
d_ms = diff(batt_run_ms);
d_t = diff(batt_run_sevcon_time_processed);
acceleration_ms2 = d_ms./d_t;

figure;
plot(batt_run_sevcon_time_processed(1:end-1),acceleration_ms2)
grid on
xlim([0,1200])
title("Acceleration Achieved on Drive Cycle")
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')

%motor torque graph
figure;
plot(batt_run_sevcon_time_processed, batt_run_torques)
grid on
xlim([0,1200])
title("Motor Torque on Drive Cycle")
xlabel('Time (s)')
ylabel('Torque (Nm)')

%I THINK WE NEED TO DO AN FC CHARACTERIZATION TO CHARACHTERIZE PRESSURE VS
%OUTPUT FOR THE FC

