#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "colors.h"

static int mic_muted;
static int mic_volume;

void update_microphone_volume() {
	FILE* proc;
	int result;

	// Check if muted
	proc = popen("pactl get-source-mute @DEFAULT_SOURCE@", "r");
	if (!proc) goto mic_err;

	char buf[0x100];
	result = fread(buf, sizeof(char), 7, proc);
	pclose(proc);
	if (result < 7) goto mic_err;

	// Microrphone is muted
	if (buf[6] == 'y') {
		mic_muted = 1;
		return;
	} else {
		mic_muted = 0;
	}

	// Get volume
	proc = popen("pactl get-source-volume @DEFAULT_SOURCE@", "r");
	if (!proc) goto mic_err;

	result = fread(buf, 1, 0x100, proc);
	pclose(proc);
	if (result <= 0) goto mic_err;

	char* volume_str = strchr(buf, '/');
	if (volume_str == NULL) goto mic_err;

	while (*++volume_str && (*volume_str < '0' || *volume_str > '9'));
	if (!*volume_str) goto mic_err;
	
	char* end_num = strchr(volume_str, ' ');
	if (end_num != NULL) *end_num = '\0';

	mic_volume = atoi(volume_str);

	return;

mic_err:
	fprintf(stderr, "Microphone: %s\n", strerror(errno));
	mic_volume = -1;
}

void print_microphone_volume() {
	update_microphone_volume();
	if (mic_volume == -1) {
		START_RED;
		printf("Mic error");
		END_COLOR;
	} else if (mic_muted) {
		START_YELLOW;
		printf("Mic muted");
		END_COLOR;
	} else {
		if (mic_volume < 10) START_YELLOW;
		else if (mic_volume >= 100) START_RED;
		else START_WHITE;

		printf("Mic %d%%", mic_volume);

		END_COLOR;
	}
}
