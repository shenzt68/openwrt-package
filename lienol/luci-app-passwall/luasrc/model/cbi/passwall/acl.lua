local sys = require"luci.sys"
local webadmin = require"luci.tools.webadmin"

m=Map("passwall")
s=m:section(TypedSection,"acl_rule",translate("ACLs"),
translate("ACLs is a tools which used to designate specific IP proxy mode"))
s.template="cbi/tblsection"
s.sortable=true
s.anonymous=true
s.addremove=true

o=s:option(Flag,"enabled",translate("Enable"))
o.rmempty=false

o=s:option(Value,"aclremarks",translate("ACL Remarks"))
o.rmempty=true

o=s:option(Value,"ipaddr",translate("IP Address"))
o.datatype="ip4addr"
o.rmempty=true

local temp={}
for index, n in ipairs(luci.ip.neighbors({ family = 4 })) do
	if n.dest then
		temp[index]=n.dest:string()
	end
end
local ips = {}   
for _,key in pairs(temp) do table.insert(ips,key) end 
table.sort(ips)

for index,key in pairs(ips) do o:value(key,temp[key]) end
--webadmin.cbi_add_knownips(o)

o=s:option(Value,"macaddr",translate("MAC Address"))
o.rmempty=true
sys.net.mac_hints(function(e,t)
o:value(e,"%s (%s)"%{e,t})
end)

o=s:option(ListValue,"proxy_mode",translate("Proxy Mode"))
o.default="disable"
o.rmempty=false
o:value("disable",translate("No Proxy"))
o:value("global",translate("Global Proxy"))
o:value("gfwlist",translate("GFW List"))
o:value("chnroute",translate("China WhiteList"))
o:value("gamemode",translate("Game Mode"))
o:value("returnhome",translate("Return Home"))

o=s:option(Value,"tcp_redir_ports",translate("TCP Redir Ports"))
o.default="default"
o:value("default",translate("Default"))
o:value("1:65535",translate("All"))
o:value("80,443","80,443")
o:value("80:","80 "..translate("or more"))
o:value(":443","443 "..translate("or less"))

o=s:option(Value,"udp_redir_ports",translate("UDP Redir Ports"))
o.default="default"
o:value("default",translate("Default"))
o:value("1:65535",translate("All"))
o:value("53","53")
return m
