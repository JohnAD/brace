export sys/types.h
export sys/socket.h
export sys/uio.h

use net

def TCP_CORK TCP_NOPUSH
  # see http://dotat.at/writing/nopush.html, disabling NOPUSH does not send

def sendfile(out_fd, in_fd, offset, count) sendfile(in_fd, out_fd, *offset, count, NULL, offset, 0)

int freebsd_net  # placeholder
