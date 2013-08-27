#include <urweb.h>

// track which ends have been closed on urweb side
//
typedef int uw_System_pipe[4]; // 0,1 are pipe ids, 2,3 is zero if pipe is closed

#define UW_SYSTEM_PIPE_INIT(x) { x[2] = 0; x[3]=0; }
#define UW_SYSTEM_PIPE_CLOSE_IN(x)  { close(x[1]); x[3] = 0; }
#define UW_SYSTEM_PIPE_CLOSE_OUT(x) { close(x[0]); x[2] = 0; }
#define UW_SYSTEM_PIPE_CLOSE(x) { \
  if (x[2]) { close(x[0]); x[2] = 0; } \
  if (x[3]) { close(x[1]); x[3] = 0; } \
}
#define UW_SYSTEM_PIPE_CREATE_OR_URWEB_ERROR(x) {               \
  if (pipe(x) >= 0){                                            \
      x[2] = 1;                                                 \
      x[3] = 1;                                                 \
  } else {                                                      \
    uw_error(ctx, FATAL, "failed creating pipe %s", cmd);       \
  }                                                             \
}                                                               \

typedef struct {
  uw_System_pipe ur_to_cmd;
  uw_System_pipe cmd_to_ur;
  int pid;
  int status;
  int bufsize;
  uw_Basis_blob blob;
} uw_Process_result_struct;


typedef uw_Process_result_struct *uw_Process_result;

uw_Process_result uw_Process_exec( uw_context ctx, uw_Basis_string cmd, uw_Basis_blob stdin_, uw_Basis_int bufsize);
uw_Basis_int      uw_Process_status      (uw_context ctx, uw_Process_result result);
uw_Basis_blob     uw_Process_blob        (uw_context ctx, uw_Process_result result);
uw_Basis_bool     uw_Process_buf_full    (uw_context ctx, uw_Process_result result);
uw_Basis_string   uw_Process_blobText (uw_context ctx, uw_Basis_blob blob);
uw_Basis_string   uw_Process_blobXml (uw_context ctx, uw_Basis_blob blob);

