---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by z15085.
--- DateTime: 2019/9/5 18:01
---

local args = nil

local request_method = ngx.var.request_method
if "GET" == request_method then
    args = ngx.req.get_uri_args()
elseif "POST" == request_method then
    ngx.req.read_body()
    args = ngx.req.get_post_args()
    if (args == nil or args.data == null) then
        args = ngx.req.get_uri_args()
    end
end

local name = args.name

ngx.say("hello:" .. name)
