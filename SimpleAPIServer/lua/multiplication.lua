---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xxw.
--- DateTime: 2019/9/8 22:56
---

local args = ngx.req.get_uri_args()
ngx.say(args.a * args.b)