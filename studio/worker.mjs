const PAGE=String.raw`<!doctype html>
<html lang="zh-CN"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#0b1120"><meta name="description" content="SwiftUI Studio — 免费原生 iOS 云开发控制台">
<title>SwiftUI Studio · 云端开发控制台</title>
<style>
:root{color-scheme:dark;--bg:#080e1a;--panel:#111b2d;--panel2:#142239;--line:#26364f;--text:#ecf3ff;--muted:#8fa5c4;--blue:#6da7ff;--cyan:#47ddd2;--green:#5ad7a0;--red:#fb8f99;--amber:#f7c875}
*{box-sizing:border-box}body{margin:0;background:radial-gradient(ellipse at 75% 0%,#122849 0,transparent 42%),var(--bg);color:var(--text);font:15px/1.55 -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;min-height:100vh}
a{color:inherit;text-decoration:none}button,select,textarea{font:inherit}button{cursor:pointer}
.shell{display:grid;grid-template-columns:252px minmax(0,1fr);min-height:100vh}
.side{background:#0b1424;border-right:1px solid var(--line);padding:30px 17px;display:flex;flex-direction:column;gap:27px;position:sticky;top:0;height:100vh}
.brand{display:flex;align-items:center;gap:12px;padding:0 9px}.logo{width:39px;height:39px;border-radius:13px;background:linear-gradient(145deg,#7ab0ff,#4255b4);display:grid;place-items:center;font-weight:800;font-size:22px}
.brand b{font-size:18px;letter-spacing:-.5px}.sub{color:var(--muted);font-size:11px;letter-spacing:1px}.nav{display:grid;gap:5px}.nav button{background:transparent;border:1px solid transparent;text-align:left;color:var(--muted);padding:12px 15px;border-radius:11px;display:flex;align-items:center;gap:13px;font-weight:600}.nav button.active{background:#203657;border-color:#304f75;color:#e4f0ff}.nav button:hover{color:#fff;background:#1a2b45}.bullet{width:9px;height:9px;border:2px solid currentColor;border-radius:3px;opacity:.8}
.side-foot{margin-top:auto;border:1px solid var(--line);border-radius:13px;padding:14px;background:#101c31}.side-foot .flag{color:var(--green);font-weight:700;font-size:13px}
main{min-width:0;padding:33px clamp(16px,4.2vw,64px) 90px;max-width:1480px;width:100%;margin:auto}
.top{display:flex;justify-content:space-between;gap:20px;align-items:center;margin-bottom:27px}.eyebrow{font-size:11px;letter-spacing:2px;text-transform:uppercase;color:var(--cyan);font-weight:750;margin-bottom:7px}
h1{font-size:clamp(27px,3vw,38px);letter-spacing:-1.1px;line-height:1.2;margin:0 0 9px;font-weight:750}h2{font-size:18px;margin:0}h3{font-size:14px;margin:0 0 8px;color:#d8e7fa}.hint,.muted{color:var(--muted)}.hint{font-size:13px;margin:0}.actions{display:flex;gap:9px;flex-wrap:wrap}.btn{display:inline-flex;justify-content:center;align-items:center;gap:7px;border:1px solid #344966;border-radius:10px;padding:10px 14px;background:#192940;color:#e4eeff;font-size:13px;font-weight:650;min-height:41px}.btn.primary{background:linear-gradient(140deg,#428ef1,#4869c7);border-color:#578de3;color:white}.btn:hover{filter:brightness(1.15)}.btn:focus-visible,.nav button:focus-visible{outline:2px solid var(--cyan);outline-offset:3px}
.tab{display:none}.tab.active{display:block}.grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;margin:19px 0 23px}.box{background:linear-gradient(160deg,#142139,#101a2c);border:1px solid var(--line);border-radius:17px;padding:19px;min-width:0}.stat-label{color:#a2b5ce;font-size:12px;font-weight:650;margin:0 0 15px}.stat-num{font-size:26px;font-weight:760;letter-spacing:-.8px;line-height:1.2;overflow-wrap:anywhere}.stat-foot{font-size:12px;color:var(--muted);margin:9px 0 0}
.ok{color:var(--green)}.bad{color:var(--red)}.pending{color:var(--amber)}.dot{display:inline-block;width:8px;height:8px;background:currentColor;border-radius:50%;margin-right:6px}
.duo{display:grid;grid-template-columns:1.45fr 1fr;gap:17px}.section-title{display:flex;align-items:center;justify-content:space-between;margin-bottom:15px;gap:12px}.section-title span{color:var(--muted);font-size:12px}
.line-item{display:flex;justify-content:space-between;align-items:center;gap:18px;padding:14px 0;border-top:1px solid #28354a}.line-item:first-child{border-top:0}.line-main{min-width:0}.line-main b{font-size:13px;display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.line-main small{font-size:11px;color:var(--muted)}.pill{font-size:11px;border-radius:100px;padding:4px 9px;white-space:nowrap;border:1px solid #38495e;background:#1c2c42}.pill.success{color:#6ee2ae;border-color:#1d6454;background:#143a35}.pill.failure{color:#ff9ba4;border-color:#673848;background:#3e2637}.pill.progress{color:#fdd494;border-color:#695138;background:#413329}
.link{font-size:12px;color:#8dbdff}.link:hover{text-decoration:underline}.notice{padding:14px 17px;margin-bottom:21px;background:#102c33;border:1px solid #285c64;border-radius:13px;color:#bceee9;font-size:13px}
.workspace{display:grid;grid-template-columns:250px minmax(0,1fr);gap:15px;margin-top:20px}.filelist{display:grid;align-content:start;gap:7px}.fileitem{border:1px solid transparent;background:none;color:var(--muted);text-align:left;padding:11px;border-radius:9px;font-size:12px;word-break:break-all}.fileitem.current{border-color:#355578;background:#1b3050;color:#e7f0ff}.fileitem:hover{color:white}.editor{width:100%;min-height:360px;max-height:70vh;background:#0b1424;border:1px solid #2d4160;border-radius:12px;padding:15px;color:#dfebfb;font:12px/1.65 ui-monospace,SFMono-Regular,Menlo,monospace;resize:vertical;tab-size:2;outline-offset:3px}.editor:focus{outline:1px solid #5596de}
.editor-head{display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:11px}.editor-head strong{font-size:12px;overflow-wrap:anywhere}.editor-actions{display:flex;gap:7px;flex-wrap:wrap}.caption{font-size:12px;color:var(--muted);margin-top:11px}.steps{display:grid;gap:13px;margin-top:18px}.step{display:flex;gap:15px;align-items:flex-start;padding:16px;border:1px solid var(--line);border-radius:13px;background:#111e32}.step-index{width:29px;height:29px;flex-shrink:0;border-radius:9px;background:#254b7a;color:#c3e5ff;display:grid;place-items:center;font-weight:800}.step p{font-size:13px;color:var(--muted);margin:3px 0 0}
.empty{padding:27px;color:var(--muted);font-size:13px;text-align:center}.foot{border-top:1px solid var(--line);margin-top:25px;padding-top:17px;font-size:12px;color:var(--muted)}
.topbar-mini{display:none}.loading{opacity:.8}.tag{font-size:11px;color:#9fb8d6;border:1px solid #344863;border-radius:5px;padding:2px 6px;letter-spacing:.3px}
@media(max-width:1100px){.grid{grid-template-columns:repeat(2,minmax(0,1fr))}.duo{grid-template-columns:1fr}}
@media(max-width:760px){.shell{grid-template-columns:1fr}.side{display:none}main{padding:20px 15px 100px}.top{align-items:flex-start;flex-direction:column;gap:15px}.grid{gap:10px;margin-top:13px}.box{padding:15px}.stat-num{font-size:23px}.workspace{grid-template-columns:1fr}.filelist{display:flex;overflow:auto;white-space:nowrap}.fileitem{flex-shrink:0}.topbar-mini{display:flex;align-items:center;justify-content:space-between;margin-bottom:22px}.mobile-nav{display:grid;grid-template-columns:repeat(4,1fr);position:fixed;bottom:0;left:0;right:0;background:#101a2b;border-top:1px solid var(--line);padding:8px 4px calc(8px + env(safe-area-inset-bottom));z-index:50}.mobile-nav button{background:none;border:none;border-radius:8px;color:var(--muted);padding:8px 3px;font-size:12px;font-weight:700}.mobile-nav button.active{background:#263d5c;color:white}.editor{min-height:330px}.notice{font-size:12px}}
@media(min-width:761px){.mobile-nav{display:none}}
</style>
</head><body>
<div class="shell">
<aside class="side"><div class="brand"><span class="logo">S</span><div><b>SwiftUI Studio</b><div class="sub">CLOUD DEVELOPER</div></div></div>
<div class="nav"><button data-tab="home" class="active"><span class="bullet"></span>总览 Dashboard</button><button data-tab="code"><span class="bullet"></span>SwiftUI 代码</button><button data-tab="builds"><span class="bullet"></span>构建与模拟器</button><button data-tab="guide"><span class="bullet"></span>使用指南</button></div>
<div class="side-foot"><div class="flag"><span class="dot"></span>公开仓库 · 免费路线</div><div class="muted" style="font-size:12px;margin-top:8px">Cloudflare 只读控制台<br>GitHub Actions 执行 Xcode</div></div></aside>
<main>
<div class="topbar-mini"><strong>◈ SwiftUI Studio</strong><span class="tag">CLOUDFLARE</span></div>
<header class="top"><div><div class="eyebrow">NATIVE IOS · CLOUD WORKSPACE</div><h1 id="pageTitle">开发总览</h1><p class="hint">New-ios-swi · SwiftUI · Xcode 26.6 · 无需本地 Mac</p></div>
<div class="actions"><button id="refreshBtn" class="btn" type="button">↻ 刷新状态</button><a class="btn primary" href="https://github.dev/yichaochen225-bot/New-ios-swi" target="_blank" rel="noopener noreferrer">打开网页版编辑器 ↗</a></div></header>
<div id="notice" class="notice">此控制台只读取公开仓库数据，不会保存 GitHub 密码或令牌。修改和提交代码请使用 GitHub 登录后的网页编辑器。</div>
<section class="tab active" id="tab-home">
<div class="grid">
<article class="box"><div class="stat-label">主分支</div><div class="stat-num" id="statBranch">main</div><p class="stat-foot" id="statSha">正在获取提交…</p></article>
<article class="box"><div class="stat-label">最新构建</div><div class="stat-num" id="statBuild">—</div><p class="stat-foot" id="statBuildDetail">正在检查 Actions</p></article>
<article class="box"><div class="stat-label">待处理 PR</div><div class="stat-num" id="statPrs">—</div><p class="stat-foot">变更需要代码审查</p></article>
<article class="box"><div class="stat-label">构建环境</div><div class="stat-num" style="font-size:22px">Xcode 26.6</div><p class="stat-foot">GitHub Hosted macOS 26</p></article>
</div>
<div class="duo"><section class="box"><div class="section-title"><h2>最近的编译任务</h2><button class="btn" type="button" data-tab="builds">全部构建 →</button></div><div id="recentRuns" class="loading">加载中…</div></section>
<section class="box"><div class="section-title"><h2>快捷操作</h2><span>无令牌 · 无付费 API</span></div><div class="steps">
<div><a class="btn primary" style="width:100%" href="https://github.com/yichaochen225-bot/New-ios-swi/edit/main/FreeSwiftUIStarter/ContentView.swift" target="_blank" rel="noopener noreferrer">在 GitHub 编辑 ContentView.swift ↗</a><p class="caption">受保护主分支会引导你创建分支或 PR。</p></div>
<div><a class="btn" style="width:100%" href="https://github.com/yichaochen225-bot/New-ios-swi/actions/workflows/ios-ci.yml" target="_blank" rel="noopener noreferrer">查看 / 手动运行 Xcode 编译 ↗</a></div>
<div><a class="btn" style="width:100%" href="https://github.com/yichaochen225-bot/New-ios-swi/pulls" target="_blank" rel="noopener noreferrer">查看并审查 Pull Requests ↗</a></div></div></section></div>
</section>
<section class="tab" id="tab-code"><div class="section-title"><h2>SwiftUI 文件预览与临时草稿</h2><span>读取 main 分支</span></div>
<p class="hint">可在这里修改文字、复制草稿；直接提交请点击 GitHub 编辑按钮。此页面不自动保存草稿，也不持有仓库写入权限。</p>
<div class="workspace"><aside class="box filelist" id="fileList"></aside><section class="box">
<div class="editor-head"><strong id="currentFile">ContentView.swift</strong><div class="editor-actions"><button id="copyBtn" class="btn" type="button">复制草稿</button><a id="editFileLink" class="btn primary" href="https://github.com/yichaochen225-bot/New-ios-swi" target="_blank" rel="noopener noreferrer">登录 GitHub 编辑 ↗</a></div></div>
<textarea class="editor" id="codeEditor" spellcheck="false" aria-label="SwiftUI 代码编辑区" placeholder="正在加载 SwiftUI 文件…"></textarea><div id="draftNotice" class="caption">正在从 GitHub 加载代码…</div>
</section></div></section>
<section class="tab" id="tab-builds"><div class="section-title"><h2>GitHub Actions 构建与模拟器测试</h2><a class="link" target="_blank" rel="noopener noreferrer" href="https://github.com/yichaochen225-bot/New-ios-swi/actions">在 GitHub 查看全部 ↗</a></div>
<div class="notice">PR 会执行 Xcode 编译及 iPhone 模拟器启动与截图；main 提交默认只编译。模拟器截图在对应运行的 Artifacts 中下载。</div>
<div class="box"><div id="allRuns" class="loading">加载中…</div></div>
<div class="box" style="margin-top:17px"><div class="section-title"><h2>待审查的 Pull Requests</h2><a class="link" target="_blank" rel="noopener noreferrer" href="https://github.com/yichaochen225-bot/New-ios-swi/pulls">打开 GitHub ↗</a></div><div id="allPrs">加载中…</div></div>
</section>
<section class="tab" id="tab-guide"><h2>如何从 iPhone 开发原生苹果 App</h2>
<div class="steps"><div class="step"><span class="step-index">1</span><div><h3>编写 SwiftUI 代码</h3><p>进入「SwiftUI 代码」，预览 ContentView.swift；通过 github.dev 或 GitHub 编辑页修改实际仓库代码。</p></div></div>
<div class="step"><span class="step-index">2</span><div><h3>创建 PR 并编译</h3><p>提交到功能分支并创建 Pull Request。GitHub 免费标准 macOS 运行器将自动使用 Xcode 26.6 编译。</p></div></div>
<div class="step"><span class="step-index">3</span><div><h3>检查模拟器截图</h3><p>PR 的 Actions 页面中找到 ios-swiftui-build 构建产物；其中的 iphone-simulator.png 是真正模拟器执行后的截图。</p></div></div>
<div class="step"><span class="step-index">4</span><div><h3>人工合并</h3><p>只有测试通过并完成审查后才合并到 main。保留现有 GitHub Ruleset；不让 Cloudflare 直接提交或合并。</p></div></div>
<div class="step"><span class="step-index">5</span><div><h3>真机安装另外配置</h3><p>当前生成的是未签名模拟器 App，无法直接安装到实体 iPhone。后续需要 Apple 签名或 TestFlight 方案。</p></div></div></div>
<div class="foot">技术边界：Cloudflare Worker 不运行 macOS / Xcode；实际编译发生在 GitHub Actions。公开仓库和公开构建日志不要存储密码、私人数据或密钥。</div></section>
<div class="foot" id="lastUpdated">读取公开 GitHub API · 每 60 秒刷新状态</div>
</main></div>
<nav class="mobile-nav" aria-label="移动端导航"><button data-tab="home" class="active">总览</button><button data-tab="code">代码</button><button data-tab="builds">构建</button><button data-tab="guide">指南</button></nav>
<script>
(function(){
'use strict';
var REPO='https://github.com/yichaochen225-bot/New-ios-swi';
var FILES=['FreeSwiftUIStarter/ContentView.swift','FreeSwiftUIStarter/FreeSwiftUIStarterApp.swift','FreeSwiftUIStarter.xcodeproj/project.pbxproj','.github/workflows/ios-ci.yml','scripts/simulator-smoke-test.sh'];
var selected=FILES[0],loaded='',dirty=false,overview=null;
function el(id){return document.getElementById(id);}
function text(id,value){el(id).textContent=value;}
function when(iso){if(!iso)return '时间未知';var d=new Date(iso);return isNaN(d.getTime())?'时间未知':d.toLocaleString('zh-CN',{month:'short',day:'numeric',hour:'2-digit',minute:'2-digit'});}
function status(run){if(!run)return '未知';if(run.status!=='completed')return run.status==='queued'?'排队中':'执行中';return run.conclusion==='success'?'成功':run.conclusion==='cancelled'?'已取消':'失败';}
function klass(run){if(run.status!=='completed')return 'progress';return run.conclusion==='success'?'success':'failure';}
function clear(node){while(node.firstChild)node.removeChild(node.firstChild);}
function newEl(tag,cls,label){var n=document.createElement(tag);if(cls)n.className=cls;if(label!==undefined)n.textContent=label;return n;}
function runRow(r){
var row=newEl('div','line-item'),main=newEl('div','line-main'),title=newEl('a',null,(r.name||'Xcode 编译')+' #'+r.run_number);
title.href=REPO+'/actions/runs/'+r.id;title.target='_blank';title.rel='noopener noreferrer';title.style.fontWeight='700';title.style.fontSize='13px';
main.appendChild(title);main.appendChild(newEl('small',null,(r.head_branch||'main')+' · '+when(r.created_at)+' · '+(r.event==='pull_request'?'PR 测试':'主分支/手动')));
row.appendChild(main);row.appendChild(newEl('span','pill '+klass(r),status(r)));return row;
}
function prRow(r){var row=newEl('div','line-item'),main=newEl('div','line-main'),link=newEl('a',null,'#'+r.number+' '+(r.title||'Pull Request'));
link.href=REPO+'/pull/'+r.number;link.rel='noopener noreferrer';link.target='_blank';link.style.fontSize='13px';link.style.fontWeight='700';
main.appendChild(link);main.appendChild(newEl('small',null,when(r.created_at)));row.appendChild(main);row.appendChild(newEl('span','pill',r.draft?'草稿':'待审查'));return row;}
function render(){
if(!overview)return;
var runs=overview.runs||[],prs=overview.prs||[],branch=overview.branch||{};
text('statSha',branch.commit&&branch.commit.sha?'提交 '+branch.commit.sha.slice(0,8):'无法读取分支');
text('statPrs',String(prs.length));
var latest=runs.find(function(r){return r.head_branch==='main';})||runs[0];
text('statBuild',latest?status(latest):'暂无');
el('statBuild').className='stat-num '+(latest?latest.conclusion==='success'?'ok':latest.status==='completed'?'bad':'pending':'');
text('statBuildDetail',latest?'#'+latest.run_number+' · '+when(latest.updated_at):'暂无 Actions');
var containers=[el('recentRuns'),el('allRuns')];
containers.forEach(function(n,i){clear(n);var rows=i?runs:runs.slice(0,4);if(!rows.length)n.appendChild(newEl('div','empty','尚无构建记录'));else rows.forEach(function(r){n.appendChild(runRow(r));});n.classList.remove('loading');});
var list=el('allPrs');clear(list);if(!prs.length)list.appendChild(newEl('div','empty','目前没有待审查的 Pull Request'));else prs.forEach(function(p){list.appendChild(prRow(p));});
text('lastUpdated','最近更新：'+new Date().toLocaleTimeString('zh-CN')+' · GitHub 公共 API · 60 秒自动刷新');
}
async function load(){
el('refreshBtn').disabled=true;
try{var r=await fetch('/api/overview',{cache:'no-store'});if(!r.ok)throw Error('接口 '+r.status);var j=await r.json();overview=j;render();if(j.warnings&&j.warnings.length){text('notice','部分 GitHub 数据暂时不可用：'+j.warnings.join('；')+'。可以直接打开 GitHub 操作。');}else{text('notice','已连接公开仓库，状态来自 GitHub Actions。编辑和提交代码请使用 GitHub 登录后的网页编辑器，不需要在本网站输入密钥。');}}
catch(e){text('notice','状态暂时无法更新：'+e.message+'。请使用页面的 GitHub 链接继续开发。');if(!overview){text('recentRuns','网络暂不可用');text('allRuns','网络暂不可用');}}
finally{el('refreshBtn').disabled=false;}
}
function nav(name){document.querySelectorAll('[data-tab]').forEach(function(b){b.classList.toggle('active',b.dataset.tab===name);});document.querySelectorAll('.tab').forEach(function(e){e.classList.toggle('active',e.id==='tab-'+name);});text('pageTitle',({home:'开发总览',code:'SwiftUI 代码',builds:'云端构建',guide:'使用指南'})[name]||'开发总览');if(name==='code'&&!loaded)loadFile(selected);window.scrollTo(0,0);}
function renderFiles(){var list=el('fileList');clear(list);FILES.forEach(function(p){var b=newEl('button','fileitem'+(p===selected?' current':''),p.split('/').pop());b.type='button';b.title=p;b.addEventListener('click',function(){if(dirty&&!confirm('你有尚未复制的本地草稿。切换文件将丢失草稿，是否继续？'))return;selected=p;loaded='';dirty=false;renderFiles();loadFile(p);});list.appendChild(b);});}
async function loadFile(path){var e=el('codeEditor');e.value='';e.disabled=true;text('currentFile',path);text('draftNotice','读取 GitHub main 分支…');el('editFileLink').href=REPO+'/edit/main/'+path;try{var r=await fetch('/api/file?path='+encodeURIComponent(path),{cache:'no-store'});if(!r.ok)throw Error('接口 '+r.status);var j=await r.json();loaded=j.content||'';e.value=loaded;dirty=false;text('draftNotice','文件预览来自 GitHub main。可以修改本地草稿，但必须在 GitHub 提交才能保存。');}catch(err){text('draftNotice','文件读取失败：'+err.message+'。请使用 GitHub 编辑入口。');}finally{e.disabled=false;}}
el('codeEditor').addEventListener('input',function(){dirty=this.value!==loaded;text('draftNotice',dirty?'有未保存的本地草稿。请先复制，然后使用 GitHub 编辑页提交。':'预览内容与 GitHub main 一致。');});
el('copyBtn').addEventListener('click',async function(){var code=el('codeEditor').value;try{await navigator.clipboard.writeText(code);text('draftNotice','已复制草稿。请打开 GitHub 编辑页粘贴并创建 PR。');}catch(e){el('codeEditor').focus();el('codeEditor').select();text('draftNotice','无法访问剪贴板，已选中全部代码，请使用系统复制。');}});
document.querySelectorAll('[data-tab]').forEach(function(b){b.addEventListener('click',function(){nav(b.dataset.tab);});});
el('refreshBtn').addEventListener('click',load);renderFiles();load();setInterval(function(){if(!document.hidden)load();},60000);
})();
</script></body></html>`;

const REPO='yichaochen225-bot/New-ios-swi';
const FILES=new Set(['FreeSwiftUIStarter/ContentView.swift','FreeSwiftUIStarter/FreeSwiftUIStarterApp.swift','FreeSwiftUIStarter.xcodeproj/project.pbxproj','.github/workflows/ios-ci.yml','scripts/simulator-smoke-test.sh']);
const headers={'Content-Type':'application/json; charset=utf-8','X-Content-Type-Options':'nosniff','Referrer-Policy':'no-referrer','Access-Control-Allow-Origin':'none'};
const notFound=()=>new Response('Not found',{status:404,headers:{'X-Content-Type-Options':'nosniff'}});
const json=(obj,status=200)=>new Response(JSON.stringify(obj),{status,headers:{...headers,'Cache-Control':'public, max-age=20'}});
async function github(url){
 const r=await fetch(url,{headers:{'User-Agent':'SwiftUI-Studio-Cloudflare-Worker','Accept':'application/vnd.github+json','X-GitHub-Api-Version':'2022-11-28'},signal:AbortSignal.timeout(8500),cf:{cacheTtl:20,cacheEverything:true}});
 if(!r.ok)throw Error('GitHub HTTP '+r.status);
 return r.json();
}
export default {
 async fetch(request){
  const u=new URL(request.url);
  if(request.method!=='GET'&&request.method!=='HEAD')return new Response('Method not allowed',{status:405,headers:{'Allow':'GET, HEAD'}});
  if(u.pathname==='/api/health')return json({ok:true,name:'swiftui-cloud-studio',mode:'read-only',repo:REPO});
  if(u.pathname==='/api/overview'){
   const base='https://api.github.com/repos/'+REPO;
   const names=['branch','runs','prs'];
   const urls=[base+'/branches/main',base+'/actions/runs?per_page=12',base+'/pulls?state=open&per_page=20'];
   const raw=await Promise.allSettled(urls.map(github));
   const warnings=[];
   const out={branch:null,runs:[],prs:[],warnings};
   for(let i=0;i<raw.length;i++){
    if(raw[i].status==='rejected'){warnings.push(names[i]+' 读取失败');continue;}
    const val=raw[i].value;
    if(i===0)out.branch=val;
    if(i===1)out.runs=Array.isArray(val.workflow_runs)?val.workflow_runs.map(r=>({id:r.id,name:r.name,run_number:r.run_number,status:r.status,conclusion:r.conclusion,event:r.event,head_branch:r.head_branch,created_at:r.created_at,updated_at:r.updated_at})):[]; 
    if(i===2)out.prs=Array.isArray(val)?val.map(p=>({number:p.number,title:p.title,draft:p.draft,created_at:p.created_at})):[];
   }
   return json(out);
  }
  if(u.pathname==='/api/file'){
   const path=u.searchParams.get('path')||'';
   if(!FILES.has(path))return json({error:'File not allowed'},400);
   try{
    const res=await fetch('https://raw.githubusercontent.com/'+REPO+'/main/'+path,{headers:{'User-Agent':'SwiftUI-Studio-Cloudflare-Worker'},signal:AbortSignal.timeout(8500),cf:{cacheTtl:30,cacheEverything:true}});
    if(!res.ok)throw Error('GitHub HTTP '+res.status);
    const content=await res.text();
    if(content.length>150000)return json({error:'File too large'},413);
    return json({path,ref:'main',content});
   }catch(e){return json({error:'Unable to load file'},502);}
  }
  if(u.pathname==='/'||u.pathname==='/index.html'){
   return new Response(PAGE,{headers:{'Content-Type':'text/html; charset=utf-8','Cache-Control':'no-store','X-Content-Type-Options':'nosniff','Referrer-Policy':'no-referrer','Content-Security-Policy':"default-src 'none'; script-src 'unsafe-inline'; style-src 'unsafe-inline'; connect-src 'self'; img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'; upgrade-insecure-requests"}});
  }
  return notFound();
 }
};
