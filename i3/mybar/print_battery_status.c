#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "colors.h"

void print_battery_status() {
	int to_read = 2;
	int capacity = -1;
	char status[0x100];
	status[0] = '\0';

	FILE* battery_events = fopen("/sys/class/power_supply/BAT0/uevent", "r");
	if (battery_events == NULL) goto battery_err;


	for (
		char line[0x100];
		to_read > 0 && fgets(line, sizeof(line), battery_events);
	) {
		if (status[0] == '\0' && strncmp(line + strlen("POWER_SUPPLY_"), "STATUS=", strlen("STATUS=")) == 0) {
			strcpy(status, line + strlen("POWER_SUPPLY_STATUS="));
			char* newline = strchr(status, '\n');
			if (newline == NULL) {
				fclose(battery_events);
				goto battery_err;
			}
			*newline = '\0';
		} else
		if (capacity == -1 && strncmp(line + strlen("POWER_SUPPLY_"), "CAPACITY=", strlen("CAPACITY=")) == 0) {
			capacity = atoi(line + strlen("POWER_SUPPLY_CAPACITY="));
		} else {
			continue;
		}
		to_read--;
	}
	fclose(battery_events);

	if (to_read > 0 || capacity == -1 || status[0] == '\0') goto battery_err;

	if (capacity >= 95) START_GREEN;
	else if (capacity <= 10) START_RED;
	else if (capacity <= 20) START_YELLOW;
	else START_WHITE;

	if (strcmp(status, "Discharging") == 0) {
		printf("BAT %d%%", capacity);
	} else if (strcmp(status, "Full") == 0) {
		printf("FULL %d%%", capacity);
	} else {
		printf("CHR %d%%", capacity);  // My computer is stupid and doesn't understand charging
	}
	END_COLOR;

	return;

battery_err:
	fprintf(stderr, "Battery: %s\n", strerror(errno));
	START_RED;
	printf("Bat error");
	END_COLOR;
}
