#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/uaccess.h>

#define DEVICE_NAME "myled"

static int major;

static ssize_t my_write(
    struct file *file,
    const char __user *buf,
    size_t len,
    loff_t *off)
{
    char kbuf[8];

    if(copy_from_user(kbuf, buf, len))
        return -EFAULT;

    if(kbuf[0] == '1')
    {
        printk(KERN_INFO "LED ON\n");
    }
    else if(kbuf[0] == '0')
    {
        printk(KERN_INFO "LED OFF\n");
    }

    return len;
}

static struct file_operations fops =
{
    .owner = THIS_MODULE,
    .write = my_write,
};

static int __init my_init(void)
{
    major = register_chrdev(0, DEVICE_NAME, &fops);

    printk(KERN_INFO
        "myled loaded major=%d\n",
        major);

    return 0;
}

static void __exit my_exit(void)
{
    unregister_chrdev(major, DEVICE_NAME);

    printk(KERN_INFO
        "myled unloaded\n");
}

module_init(my_init);
module_exit(my_exit);

MODULE_LICENSE("GPL");