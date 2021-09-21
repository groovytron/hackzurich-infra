variable "teams" {
  type = list(object({
    teamName = string
    pubKey = string
  }))
  default = [
      {
        teamName        = "team-red"
        pubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWYJF+cDgUZyOIoAHQlzmBV/BOl9PlOcKqLy3Vqy/eFoHABtOqNnMun2Bm3jdLzTdUCoV9N+oW+oyCYmt7NkxwiBHMe1oijRUG6amwKgeY+YQpmDymRWDr1ZY2Ww6JEG6BU33WXlF9TjfuR/SkDr1zi0g9HbJ06lNTGxqpyfQCNg7VgZAGXiOSt5RJAEzMm2DlIX3y4wJuwRNquMwQCLEzaFTCoj8U5tB0IImFYKy98CFld4+JJMMKIzIIcN7+UgLstW1yVjYl6uxXPfQFd90oop5rt7vcRlcJSdgc40Z896WxY0VyHzBWNGrssgq5umRrDFfrXeLVWQg7sehTL5BOts2D7IY8V5mbfRrLr+LKxjhwEm0cOnYdqoL/ghhPKQWyBqPZqGeuyvBGLheB96wL7uSqprW33eUjfAyICEhx82KkXM+CzwaoQChAoX/HToByOHuEm9uRAlLGupfOJpppVLrsiuWWpRoDHUUSVI0wjxvqLwXCxDNRgz4Q88Lv4+8= hackzurich"
      },
      {
        teamName        = "team-blue"
        pubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWYJF+cDgUZyOIoAHQlzmBV/BOl9PlOcKqLy3Vqy/eFoHABtOqNnMun2Bm3jdLzTdUCoV9N+oW+oyCYmt7NkxwiBHMe1oijRUG6amwKgeY+YQpmDymRWDr1ZY2Ww6JEG6BU33WXlF9TjfuR/SkDr1zi0g9HbJ06lNTGxqpyfQCNg7VgZAGXiOSt5RJAEzMm2DlIX3y4wJuwRNquMwQCLEzaFTCoj8U5tB0IImFYKy98CFld4+JJMMKIzIIcN7+UgLstW1yVjYl6uxXPfQFd90oop5rt7vcRlcJSdgc40Z896WxY0VyHzBWNGrssgq5umRrDFfrXeLVWQg7sehTL5BOts2D7IY8V5mbfRrLr+LKxjhwEm0cOnYdqoL/ghhPKQWyBqPZqGeuyvBGLheB96wL7uSqprW33eUjfAyICEhx82KkXM+CzwaoQChAoX/HToByOHuEm9uRAlLGupfOJpppVLrsiuWWpRoDHUUSVI0wjxvqLwXCxDNRgz4Q88Lv4+8= hackzurich"
      },
      {
        teamName        = "team-pink"
        pubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWYJF+cDgUZyOIoAHQlzmBV/BOl9PlOcKqLy3Vqy/eFoHABtOqNnMun2Bm3jdLzTdUCoV9N+oW+oyCYmt7NkxwiBHMe1oijRUG6amwKgeY+YQpmDymRWDr1ZY2Ww6JEG6BU33WXlF9TjfuR/SkDr1zi0g9HbJ06lNTGxqpyfQCNg7VgZAGXiOSt5RJAEzMm2DlIX3y4wJuwRNquMwQCLEzaFTCoj8U5tB0IImFYKy98CFld4+JJMMKIzIIcN7+UgLstW1yVjYl6uxXPfQFd90oop5rt7vcRlcJSdgc40Z896WxY0VyHzBWNGrssgq5umRrDFfrXeLVWQg7sehTL5BOts2D7IY8V5mbfRrLr+LKxjhwEm0cOnYdqoL/ghhPKQWyBqPZqGeuyvBGLheB96wL7uSqprW33eUjfAyICEhx82KkXM+CzwaoQChAoX/HToByOHuEm9uRAlLGupfOJpppVLrsiuWWpRoDHUUSVI0wjxvqLwXCxDNRgz4Q88Lv4+8= hackzurich"
      }
    ]
}