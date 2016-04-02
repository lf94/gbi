/*************************************************************************
 *   Cboy, a Game Boy emulator
 *   Copyright (C) 2012 jkbenaim
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ************************************************************************/

#ifdef __ANDROID__
#include <jni.h>
#include <android/log.h>
#include <android/bitmap.h>
#endif // __ANDROID__

#include <stdlib.h>
#include "types.h"
#include "input.h"
#include "cpu.h"
#include "memory.h"
#include "video.h"
#include "cart.h"
#include "main.h"
#include "audio.h"

int stop = 0;
int pause = 0;

#ifdef __ANDROID__
#define  LOG_TAG    "libcboy"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)
#endif // __ANDROID__

#ifdef USE_SDL
int main ( int argc, char* argv[] ) {

  if(argc < 3)
  {
    fprintf(stderr, "Usage: gbi boot.bin file.gb af bc de hl\n");
    exit(1);
  }

  int af = atoi(argv[3]);
  int bc = atoi(argv[4]);
  int de = atoi(argv[5]);
  int hl = atoi(argv[6]);

  mem_init();
//   audio_init();
  if( ! cpu_init(af, bc, de, hl) )
  {
    fprintf( stderr, "cpu init failed\n" );
    return 1;
  }
  cart_init( argv[1], argv[2] );
  vid_init();
  while(!stop)
  {
    vid_waitForNextFrame();
    input_handle();
    if(!pause)
    {
      cpu_do_one_frame();
      vid_frame();
    }
  }
  
  cart_cleanup();
//   audio_cleanup();
  
  return 0;
}
#endif // USE_SDL

#ifdef __ANDROID__
JNIEXPORT void JNICALL Java_org_trashfolder_cboy_CboyView_cboyInit(JNIEnv * env, jobject  obj)
{
    mem_init();
    cpu_init();
    cart_init( "/storage/emulated/0/roms/cgb_rom.bin", "/storage/emulated/0/roms/camera.gb" );
    vid_init();
    input_init();
}
#endif // __ANDROID__
