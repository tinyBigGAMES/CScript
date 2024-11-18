/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                      ___  ___           _        _ ™
                     / __|/ __| __  _ _ (_) _ __ | |_
                    | (__ \__ \/ _|| '_|| || '_ \|  _|
                     \___||___/\__||_|  |_|| .__/ \__|
                                           |_|
                                           
                 Copyright © 2024-present tinyBigGAMES™ LLC
                          All Rights Reserved.

                    Website: https://tinybiggames.com
                    Email  : support@tinybiggames.com

                 See LICENSE file for license information
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <stdio.h>
#include <miniaudio.h>

int main(void) {
    ma_result result;
    ma_engine engine;

    printf("miniaudio version: %s\n\n", ma_version_string());

    result = ma_engine_init(NULL, &engine);
    if (result != MA_SUCCESS) {
        printf("Failed to initialize audio engine.\n");
        return -1;
    }

    ma_engine_play_sound(&engine, "res/audio/song01.ogg", NULL);

    printf("Press ENTER to quit...");
    getchar();

    ma_engine_uninit(&engine);

    return 0;
}