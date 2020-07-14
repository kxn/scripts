#!/usr/bin/php
<?php

$pdo = new PDO("mysql:host=localhost;dbname=pdns", "pdns", "*pdns_pass_word*");

$stm = $pdo->query("select records.name as record_name, records.type as record_type, content, ttl, prio, domains.name as domain_name, domains.type as domain_type from records, domains where records.domain_id = domains.id");

$rows = $stm->fetchAll(PDO::FETCH_ASSOC);

$domains = array();

foreach($rows as $r) {
    if ($r["record_type"] != "A") continue;
    if (!isset($domains[$r["domain_name"]])) {
       $d = array ();
       if ($r["domain_type"] == "MASTER") $d["type"] = "static";
       else $d["type"] = "typetransparent";
       $d["data"] = [];
       $domains[$r["domain_name"]] = $d;
    }
    $domain = &$domains[$r["domain_name"]];
    if (strpos($r["record_name"], "*.") !== false) {
       $domain["type"] = "redirect";
       $domain["data"][] = sprintf("local-data: \"%s %d IN A %s\"", $r["domain_name"], $r["ttl"], $r["content"]);
    } else {
       $domain["data"][] = sprintf("local-data: \"%s %d IN A %s\"", $r["record_name"], $r["ttl"], $r["content"]);
    }
}

$text = "";
foreach ($domains as $n => $d) {
    $text .= sprintf("\nlocal-zone: \"%s\" %s\n", $n, $d["type"]);
    $text .= "  ". implode("\n  ", $d["data"]);
    $text .= "\n";
}

$oldtext = file_get_contents("/etc/unbound/local.d/dns.conf");

if ($oldtext != $text) {
   file_put_contents("/etc/unbound/local.d/dns.conf", $text);
   system("/usr/sbin/unbound-control reload");
}
