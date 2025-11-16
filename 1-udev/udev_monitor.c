#include <libudev.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    struct udev *udev;
    struct udev_monitor *mon;
    int fd;

    // Создаем объект udev
    udev = udev_new ();
    if (!udev) {
        fprintf(stderr, "Can't create udev\n");
        exit(1);
    }

    // Создаем монитор для прослушивания событий ядра
    mon = udev_monitor_new_from_netlink(udev, "udev");
    if (!mon) {
        fprintf(stderr, "Can't create udev monitor\n");
        udev_unref(udev);
        exit(1);
    }

    // Начинаем мониторинг событий
    udev_monitor_enable_receiving(mon);
    fd = udev_monitor_get_fd(mon);

    printf("Listening for udev events...\n");
    while (1) {
        fd_set fds;
        struct timeval tv;
        int ret;

        FD_ZERO(&fds);
        FD_SET(fd, &fds);
        tv.tv_sec = 0;
        tv.tv_usec = 0;

        ret = select(fd+1, &fds, NULL, NULL, &tv);

        if (ret > 0 && FD_ISSET(fd, &fds)) {
            struct udev_device *dev = udev_monitor_receive_device(mon);
            if (dev) {
                printf("Got Device\n");
                printf("  Node: %s\n", udev_device_get_devnode(dev));
                printf("  Action: %s\n", udev_device_get_action(dev));
                printf("  Subsystem: %s\n", udev_device_get_subsystem(dev));
                printf("  Devtype: %s\n", udev_device_get_devtype(dev));
                udev_device_unref(dev);
            }
        }
    }

    udev_unref(udev);
    return 0;
}

// Got Device
//   Node: /dev/input/event5
//   Action: add
//   Subsystem: input
//   Devtype: (null)

// scan all /dev/input/event*
