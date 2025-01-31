% Satellite Power System Simulation
clc;
clear;

% Simulation parameters
time = 0:1:1440;  % 1-minute intervals over 1 day (1440 minutes)
solar_panel_efficiency = 0.2;  % Solar panel efficiency
solar_panel_area = 2;  % m^2 (area of the solar panels)
solar_irradiance = 1361;  % W/m^2 (solar constant)
battery_capacity = 5000;  % Wh (battery capacity)
battery_charge = 2500;  % Initial charge in Wh
satellite_power_consumption = 200;  % W (constant power consumption)
orbital_period = 90;  % Minutes per orbit (assumed for a low-Earth orbit)
daylight_duration = 60;  % Minutes in sunlight per orbit

% Pre-allocate arrays to store results
power_generated = zeros(size(time));
battery_charge_level = zeros(size(time));
power_consumed = zeros(size(time));
solar_irradiance_profile = zeros(size(time));

% Simulation loop
for t = 1:length(time)
    % Determine if the satellite is in sunlight or eclipse
    if mod(time(t), orbital_period) < daylight_duration
        % In sunlight
        solar_irradiance_profile(t) = solar_irradiance;
    else
        % In eclipse
        solar_irradiance_profile(t) = 0;
    end
    
    % Power generated by solar panels (W)
    power_generated(t) = solar_panel_efficiency * solar_panel_area * solar_irradiance_profile(t);
    
    % Power consumed by the satellite (W)
    power_consumed(t) = satellite_power_consumption;
    
    % Update battery charge level (Wh)
    net_power = power_generated(t) - power_consumed(t);  % Net power generation
    battery_charge = battery_charge + net_power / 60;  % Update battery charge (convert W to Wh)
    
    % Limit battery charge to the battery's capacity
    if battery_charge > battery_capacity
        battery_charge = battery_capacity;
    elseif battery_charge < 0
        battery_charge = 0;  % Battery cannot have negative charge
    end
    
    battery_charge_level(t) = battery_charge;
end

% Plot results
figure;

subplot(3,1,1);
plot(time, power_generated);
title('Power Generated by Solar Panels (W)');
xlabel('Time (minutes)');
ylabel('Power (W)');

subplot(3,1,2);
plot(time, battery_charge_level);
title('Battery Charge Level (Wh)');
xlabel('Time (minutes)');
ylabel('Charge (Wh)');

subplot(3,1,3);
plot(time, power_consumed);
title('Power Consumed by Satellite (W)');
xlabel('Time (minutes)');
ylabel('Power (W)');
