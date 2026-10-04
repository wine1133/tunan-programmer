(function () {
  var apiBase = window.__TU_NAN_API_BASE__ || window.location.origin
  var lastRoute = ""

  function escapeHtml(value) {
    return String(value == null ? "" : value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;")
  }

  function api(path) {
    return fetch(apiBase + path, { cache: "no-store", headers: { "bypass-tunnel-reminder": "true" } }).then(function (response) {
      if (!response.ok) throw new Error("HTTP " + response.status)
      return response.json()
    })
  }

  function currentRoute() {
    return window.location.hash.replace(/^#/, "").split("?")[0]
  }

  function pageBody() {
    return document.querySelector("uni-page-body")
  }

  function injectCss() {
    if (document.getElementById("tunan-tab-style")) return
    var style = document.createElement("style")
    style.id = "tunan-tab-style"
    style.textContent = [
      "html,body{overflow-x:hidden!important}uni-page-body{padding-bottom:80px!important;box-sizing:border-box}.tt-page{min-height:100vh;box-sizing:border-box;padding:10px 12px 90px;background:#f5f7f6;font-family:-apple-system,BlinkMacSystemFont,'PingFang SC','Microsoft YaHei',sans-serif;color:#17211d}",
      ".tt-hero{position:relative;overflow:hidden;padding:22px 18px;border-radius:15px;background:linear-gradient(135deg,#00b783,#087f6b);color:#fff;box-shadow:0 8px 18px rgba(0,167,118,.2)}",
      ".tt-hero.blue{background:linear-gradient(135deg,#2f80ed,#2458bd);box-shadow:0 8px 18px rgba(47,128,237,.22)}",
      ".tt-kicker{font-size:10px;letter-spacing:1px;opacity:.8}.tt-title{margin-top:8px;font-size:21px;font-weight:700}.tt-desc{margin-top:6px;font-size:12px;opacity:.86}",
      ".tt-section{display:flex;justify-content:space-between;align-items:center;margin:18px 2px 10px;font-size:16px;font-weight:700}.tt-count{font-size:11px;color:#8b9691;font-weight:400}",
      ".tt-grid{display:flex;flex-wrap:wrap;justify-content:space-between}.tt-card{width:calc(50% - 6px);box-sizing:border-box;margin-bottom:12px;padding:14px 11px 12px;border-radius:13px;background:#fff;box-shadow:0 5px 12px rgba(24,48,39,.06)}",
      ".tt-icon{display:flex;align-items:center;justify-content:center;width:38px;height:38px;border-radius:12px;background:#e9f9f3;color:#00a575;font-size:19px}.tt-name{margin-top:11px;font-size:14px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.tt-meta{margin-top:5px;font-size:11px;color:#9aa39f}",
      ".tt-summary{display:flex;align-items:center;margin:-12px 12px 0;padding:13px 0;border-radius:11px;background:#fff;box-shadow:0 5px 14px rgba(28,50,42,.08)}.tt-stat{flex:1;text-align:center}.tt-stat b{display:block;font-size:17px}.tt-stat span{font-size:10px;color:#929d98}.tt-divider{width:1px;height:26px;background:#edf1ef}",
      ".tt-list-card{display:flex;box-sizing:border-box;margin-bottom:11px;padding:11px;border-radius:13px;background:#fff;box-shadow:0 5px 12px rgba(24,48,39,.06)}.tt-cover{flex-shrink:0;width:96px;height:70px;border-radius:9px;object-fit:cover;background:#eef2f0}.tt-info{flex:1;min-width:0;margin-left:11px}.tt-info h3{margin:0;font-size:13px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.tt-sub{margin-top:4px;font-size:10px;color:#939e99;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}",
      ".tt-progress-row{display:flex;align-items:center;margin-top:10px}.tt-progress{flex:1;height:6px;overflow:hidden;border-radius:6px;background:#edf2f0}.tt-progress i{display:block;height:100%;border-radius:6px;background:linear-gradient(90deg,#00b783,#43cda5)}.tt-percent{margin-left:7px;color:#00a575;font-size:11px;font-weight:600}",
      ".tt-foot{display:flex;justify-content:space-between;margin-top:7px;color:#9aa39f;font-size:10px}",
      ".tt-profile{overflow:hidden;border-radius:14px;background:linear-gradient(135deg,#00b783,#087f6b);color:#fff;box-shadow:0 8px 18px rgba(0,167,118,.2)}.tt-profile-top{display:flex;align-items:center;padding:19px 17px 14px}.tt-avatar{display:flex;align-items:center;justify-content:center;width:56px;height:56px;border:2px solid rgba(255,255,255,.45);border-radius:50%;background:rgba(255,255,255,.2);font-size:22px;font-weight:700}.tt-profile-main{flex:1;min-width:0;margin-left:12px}.tt-profile-main h2{margin:0;font-size:18px}.tt-profile-main p{margin:5px 0 0;font-size:11px;opacity:.82}.tt-vip{display:inline-block;margin-top:7px;padding:3px 8px;border-radius:9px;background:rgba(255,255,255,.18);font-size:10px}",
      ".tt-profile-stats{display:flex;padding:12px 0 14px;background:rgba(0,0,0,.06)}.tt-profile-stat{flex:1;text-align:center}.tt-profile-stat b{display:block;font-size:15px}.tt-profile-stat span{font-size:10px;opacity:.76}",
      ".tt-menu{margin-top:13px;padding:0 12px;border-radius:12px;background:#fff;box-shadow:0 5px 12px rgba(24,48,39,.06)}.tt-menu-row{display:flex;align-items:center;height:52px;border-bottom:1px solid #f0f3f2}.tt-menu-row:last-child{border-bottom:0}.tt-menu-icon{display:flex;align-items:center;justify-content:center;width:29px;height:29px;border-radius:9px;background:#edf9f5;color:#00a575}.tt-menu-title{flex:1;margin-left:10px;font-size:13px}.tt-badge{padding:3px 7px;border-radius:8px;background:#ff5b52;color:#fff;font-size:10px}.tt-arrow{margin-left:7px;color:#b7c0bc}",
      ".tt-video-wrap{margin:12px 12px 18px;padding:12px;border-radius:13px;background:#fff;box-shadow:0 5px 14px rgba(28,50,42,.08)}",
      ".tt-video-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px}",
      ".tt-video-title{font-size:16px;font-weight:700;color:#17211d}",
      ".tt-video-sub{margin-top:4px;font-size:11px;color:#8f9995}",
      ".tt-video-duration{padding:4px 9px;border-radius:10px;background:#e9f9f3;color:#00a575;font-size:10px}",
      ".tt-video-player{display:block;width:100%;height:190px;border-radius:12px;background:#07110d;object-fit:cover}",
      ".tt-sheet-mask{position:fixed;inset:0;z-index:99999;background:rgba(8,20,15,.45);display:flex;align-items:flex-end}",
      ".tt-sheet{width:100%;max-height:78vh;border-radius:20px 20px 0 0;background:#f6faf8;overflow:hidden;box-shadow:0 -8px 30px rgba(0,0,0,.18)}",
      ".tt-sheet-head{display:flex;align-items:center;justify-content:space-between;padding:16px 16px 10px;background:#fff;border-bottom:1px solid #edf2ef}",
      ".tt-sheet-title{font-size:16px;font-weight:700;color:#17211d}",
      ".tt-sheet-close{width:28px;height:28px;border-radius:50%;background:#eef3f1;color:#6f7d77;display:flex;align-items:center;justify-content:center;font-size:18px}",
      ".tt-sheet-body{max-height:calc(78vh - 56px);overflow-y:auto;padding:12px}",
      ".tt-info-card{margin-bottom:10px;padding:12px;border-radius:12px;background:#fff;box-shadow:0 4px 10px rgba(24,48,39,.05)}",
      ".tt-info-head{display:flex;justify-content:space-between;gap:8px}.tt-info-title{font-size:13px;font-weight:600;color:#1c2923}.tt-status{font-size:10px;color:#00a575}",
      ".tt-info-sub{margin-top:5px;color:#929d98;font-size:10px;line-height:1.5}.tt-info-value{margin-top:7px;color:#ff5b52;font-size:14px;font-weight:700}",
      ".tt-fav-card{display:flex;margin-bottom:10px;padding:10px;border-radius:12px;background:#fff}.tt-fav-img{width:84px;height:60px;border-radius:8px;object-fit:cover;background:#eef2f0}.tt-fav-info{flex:1;min-width:0;margin-left:10px}.tt-fav-info h4{margin:0;font-size:12px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.tt-fav-info p{margin:5px 0 0;font-size:10px;color:#929d98;overflow:hidden;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical}",
      ".tt-coupon{position:relative;margin-bottom:10px;padding:12px;border-radius:12px;background:linear-gradient(135deg,#fff7e8,#fff);border:1px solid #ffe0ad}.tt-coupon b{color:#ff6b2c;font-size:22px}.tt-coupon-title{display:inline-block;margin-left:6px;font-size:12px;color:#4c3a25}.tt-coupon-sub{margin-top:6px;font-size:10px;color:#9a8c78}.tt-coupon-status{position:absolute;right:10px;top:10px;font-size:10px;color:#00a575}",
      ".tt-setting-row{display:flex;align-items:center;justify-content:space-between;padding:14px 12px;background:#fff;border-bottom:1px solid #f0f3f2;font-size:12px;color:#1c2923}.tt-setting-row:last-child{border-bottom:0}.tt-setting-value{color:#00a575;font-weight:600}",
      ".tt-progress-mini{height:5px;border-radius:5px;background:#edf2f0;overflow:hidden;margin-top:7px}.tt-progress-mini i{display:block;height:100%;border-radius:5px;background:#00b783}",
      ".tt-empty{padding:45px 0;text-align:center;color:#9aa39f;font-size:12px}"
    ].join("")
    document.head.appendChild(style)
  }

  function setBody(body, key) {
    if (body.getAttribute("data-tunan-page") === key) return false
    body.setAttribute("data-tunan-page", key)
    return true
  }

  function renderClassify(body) {
    if (!setBody(body, "classify")) return
    body.innerHTML = '<div class="tt-page"><div class="tt-hero"><div class="tt-kicker">COURSE CENTER</div><div class="tt-title">选择你的学习方向</div><div class="tt-desc">覆盖开发、数据、人工智能等热门技术</div></div><div class="tt-section"><span>全部方向</span><span class="tt-count" id="tt-category-count">加载中</span></div><div class="tt-grid" id="tt-category-grid"><div class="tt-empty">正在加载分类...</div></div></div>'
    api("/api/index/nav").then(function (result) {
      var list = result.data || []
      var count = document.getElementById("tt-category-count")
      var grid = document.getElementById("tt-category-grid")
      if (!count || !grid) return
      count.textContent = list.length + " 个分类"
      grid.innerHTML = list.map(function (item, index) {
        return '<div class="tt-card" data-course-id="' + item.id + '" data-course="' + escapeHtml(item.course) + '"><div class="tt-icon icon iconfont ' + escapeHtml(item.icon) + '"></div><div class="tt-name">' + escapeHtml(item.text) + '</div><div class="tt-meta">查看课程</div></div>'
      }).join("")
      grid.querySelectorAll("[data-course-id]").forEach(function (element) {
        element.addEventListener("click", function () {
          window.location.hash = "#/pages/course/courseIntroduce/courseIntroduce?id=" + element.getAttribute("data-course-id") + "&course=" + element.getAttribute("data-course")
        })
      })
    }).catch(function () {
      var grid = document.getElementById("tt-category-grid")
      if (grid) grid.innerHTML = '<div class="tt-empty">分类加载失败</div>'
    })
  }

  function renderStudy(body) {
    if (!setBody(body, "study")) return
    body.innerHTML = '<div class="tt-page"><div class="tt-hero blue"><div class="tt-kicker">MY LEARNING</div><div class="tt-title">继续学习</div><div class="tt-desc">今天也要向前进步一点</div></div><div class="tt-summary"><div class="tt-stat"><b id="tt-study-count">0</b><span>学习课程</span></div><div class="tt-divider"></div><div class="tt-stat"><b id="tt-study-avg">0%</b><span>平均进度</span></div><div class="tt-divider"></div><div class="tt-stat"><b id="tt-study-finished">0</b><span>已完成</span></div></div><div class="tt-section"><span>最近学习</span><span class="tt-count">保持节奏</span></div><div id="tt-study-list"><div class="tt-empty">正在加载学习记录...</div></div></div>'
    api("/api/study/list?userid=2162").then(function (result) {
      var list = result.data || []
      var count = document.getElementById("tt-study-count")
      var avg = document.getElementById("tt-study-avg")
      var finished = document.getElementById("tt-study-finished")
      var box = document.getElementById("tt-study-list")
      if (!box) return
      count.textContent = list.length
      avg.textContent = (list.length ? Math.round(list.reduce(function (sum, item) { return sum + item.progress }, 0) / list.length) : 0) + "%"
      finished.textContent = list.filter(function (item) { return item.status === "finished" }).length
      if (!list.length) {
        box.innerHTML = '<div class="tt-empty">暂无学习记录</div>'
        return
      }
      box.innerHTML = list.map(function (item) {
        return '<div class="tt-list-card" data-study-id="' + item.courseId + '"><img class="tt-cover" src="' + escapeHtml(item.logo) + '"><div class="tt-info"><h3>' + escapeHtml(item.title) + '</h3><div class="tt-sub">' + escapeHtml(item.description) + '</div><div class="tt-progress-row"><div class="tt-progress"><i style="width:' + item.progress + '%"></i></div><span class="tt-percent">' + item.progress + '%</span></div><div class="tt-foot"><span>' + item.learnedLessons + '/' + item.totalLessons + ' 节</span><span>' + escapeHtml(item.lastStudyAt) + '</span></div></div></div>'
      }).join("")
      box.querySelectorAll("[data-study-id]").forEach(function (element) {
        element.addEventListener("click", function () {
          window.location.hash = "#/pages/course/courseIntroduce/courseIntroduce?id=" + element.getAttribute("data-study-id") + "&course=yes"
        })
      })
    }).catch(function () {
      var box = document.getElementById("tt-study-list")
      if (box) box.innerHTML = '<div class="tt-empty">学习记录加载失败</div>'
    })
  }

  function renderHome(body) {
    if (body.querySelector(".tt-video-wrap")) return
    var banner = body.querySelector(".index_banner_box")
    if (!banner) return

    var wrap = document.createElement("div")
    wrap.className = "tt-video-wrap"
    wrap.innerHTML = '<div class="tt-video-head"><div><div class="tt-video-title">大学生编程学习</div><div class="tt-video-sub">用专注，写下每一行成长</div></div><div class="tt-video-duration" id="tt-video-duration">加载中</div></div><div class="tt-empty" id="tt-video-loading">正在加载视频...</div>'
    banner.insertAdjacentElement("afterend", wrap)

    api("/api/index/video").then(function (result) {
      var data = result.data || {}
      var head = wrap.querySelector(".tt-video-head")
      var duration = document.getElementById("tt-video-duration")
      var loading = document.getElementById("tt-video-loading")
      if (duration) duration.textContent = (data.duration || 0) + " 秒"
      if (loading) loading.remove()
      var video = document.createElement("video")
      video.className = "tt-video-player"
      video.setAttribute("src", data.videoUrl || "")
      video.setAttribute("poster", data.posterUrl || "")
      video.setAttribute("controls", "")
      video.setAttribute("playsinline", "")
      video.setAttribute("webkit-playsinline", "")
      video.setAttribute("preload", "metadata")
      wrap.appendChild(video)
    }).catch(function () {
      var loading = document.getElementById("tt-video-loading")
      if (loading) loading.textContent = "视频加载失败"
    })
  }
  function openMenuPanel(menuId, title) {
    var mask = document.createElement("div")
    mask.className = "tt-sheet-mask"
    mask.innerHTML = '<div class="tt-sheet"><div class="tt-sheet-head"><div class="tt-sheet-title">' + escapeHtml(title) + '</div><div class="tt-sheet-close">×</div></div><div class="tt-sheet-body"><div class="tt-empty">正在加载...</div></div></div>'
    document.body.appendChild(mask)

    function close() {
      if (mask.parentNode) mask.parentNode.removeChild(mask)
    }
    mask.addEventListener("click", function (event) {
      if (event.target === mask) close()
    })
    mask.querySelector(".tt-sheet-close").addEventListener("click", close)

    var endpoints = {
      "1": "/api/user/orders?userid=2162",
      "2": "/api/user/favorites?userid=2162",
      "3": "/api/study/list?userid=2162",
      "4": "/api/user/coupons?userid=2162",
      "5": "/api/user/settings?userid=2162"
    }
    var body = mask.querySelector(".tt-sheet-body")
    api(endpoints[menuId] || "").then(function (result) {
      var data = result.data || []
      var html = ""
      if (menuId === "1") {
        html = data.map(function (item) {
          return '<div class="tt-info-card"><div class="tt-info-head"><span class="tt-info-title">' + escapeHtml(item.title) + '</span><span class="tt-status">已支付</span></div><div class="tt-info-sub">订单号：' + escapeHtml(item.orderNo) + '<br>' + escapeHtml(item.createdAt) + '</div><div class="tt-info-value">¥' + Number(item.amount).toFixed(2) + '</div></div>'
        }).join("")
      } else if (menuId === "2") {
        html = data.map(function (item) {
          return '<div class="tt-fav-card"><img class="tt-fav-img" src="' + escapeHtml(item.logo) + '"><div class="tt-fav-info"><h4>' + escapeHtml(item.title) + '</h4><p>' + escapeHtml(item.description) + '</p><div class="tt-sub">' + item.hits + ' 人学过</div></div></div>'
        }).join("")
      } else if (menuId === "3") {
        html = data.map(function (item) {
          return '<div class="tt-info-card"><div class="tt-info-head"><span class="tt-info-title">' + escapeHtml(item.title) + '</span><span class="tt-status">' + item.progress + '%</span></div><div class="tt-progress-mini"><i style="width:' + item.progress + '%"></i></div><div class="tt-info-sub">' + item.learnedLessons + '/' + item.totalLessons + ' 节 · ' + escapeHtml(item.lastStudyAt) + '</div></div>'
        }).join("")
      } else if (menuId === "4") {
        html = data.map(function (item) {
          var statusText = item.status === "available" ? "可使用" : (item.status === "used" ? "已使用" : "已过期")
          return '<div class="tt-coupon"><span class="tt-coupon-status">' + statusText + '</span><b>¥' + Number(item.amount).toFixed(0) + '</b><span class="tt-coupon-title">' + escapeHtml(item.title) + '</span><div class="tt-coupon-sub">满 ¥' + Number(item.minAmount).toFixed(0) + ' 可用 · 有效期至 ' + escapeHtml(item.expiresAt) + '</div></div>'
        }).join("")
      } else if (menuId === "5") {
        html = '<div class="tt-setting-row"><span>消息通知</span><span class="tt-setting-value">' + (result.data.messageNotify ? "已开启" : "已关闭") + '</span></div><div class="tt-setting-row"><span>自动播放视频</span><span class="tt-setting-value">' + (result.data.autoplayVideo ? "已开启" : "已关闭") + '</span></div><div class="tt-setting-row"><span>下载清晰度</span><span class="tt-setting-value">' + escapeHtml(result.data.downloadQuality) + '</span></div>'
      }
      body.innerHTML = html || '<div class="tt-empty">暂无内容</div>'
    }).catch(function () {
      body.innerHTML = '<div class="tt-empty">内容加载失败</div>'
    })
  }
  function renderMine(body) {
    if (!setBody(body, "mine")) return
    body.innerHTML = '<div class="tt-page"><div class="tt-profile"><div class="tt-profile-top"><div class="tt-avatar" id="tt-avatar">兔</div><div class="tt-profile-main"><h2 id="tt-nickname">兔南学员</h2><p id="tt-bio">正在加载...</p><span class="tt-vip" id="tt-vip">普通学员</span></div></div><div class="tt-profile-stats"><div class="tt-profile-stat"><b id="tt-days">0</b><span>学习天数</span></div><div class="tt-profile-stat"><b id="tt-hours">0</b><span>累计小时</span></div><div class="tt-profile-stat"><b id="tt-courses">0</b><span>课程数</span></div><div class="tt-profile-stat"><b id="tt-finished">0</b><span>已完成</span></div></div></div><div class="tt-menu" id="tt-menu"><div class="tt-empty">正在加载个人中心...</div></div></div>'
    api("/api/user/profile?userid=2162").then(function (result) {
      var data = result.data || {}
      var stats = data.stats || {}
      document.getElementById("tt-avatar").textContent = (data.nickname || "兔").slice(0, 1)
      document.getElementById("tt-nickname").textContent = data.nickname || ""
      document.getElementById("tt-bio").textContent = data.bio || ""
      document.getElementById("tt-vip").textContent = data.vipLevel || ""
      document.getElementById("tt-days").textContent = data.studyDays || 0
      document.getElementById("tt-hours").textContent = data.totalHours || 0
      document.getElementById("tt-courses").textContent = stats.courseCount || 0
      document.getElementById("tt-finished").textContent = stats.finishedCourses || 0
      var menu = document.getElementById("tt-menu")
      menu.innerHTML = (data.menus || []).map(function (item) {
        return '<div class="tt-menu-row" data-menu-id="' + item.id + '" data-menu-title="' + escapeHtml(item.title) + '"><div class="tt-menu-icon icon iconfont ' + escapeHtml(item.icon) + '"></div><div class="tt-menu-title">' + escapeHtml(item.title) + '</div>' + (item.badge ? '<span class="tt-badge">' + escapeHtml(item.badge) + '</span>' : '') + '<span class="tt-arrow">›</span></div>'
      }).join("")
      menu.querySelectorAll("[data-menu-id]").forEach(function (element) {
        element.addEventListener("click", function () {
          openMenuPanel(element.getAttribute("data-menu-id"), element.getAttribute("data-menu-title"))
        })
      })
    }).catch(function () {
      var menu = document.getElementById("tt-menu")
      if (menu) menu.innerHTML = '<div class="tt-empty">个人资料加载失败</div>'
    })
  }

  function render() {
    var route = currentRoute()
    var body = pageBody()
    if (!body) return

    if (lastRoute !== route) {
      document.querySelectorAll("uni-page-body").forEach(function (element) {
        element.removeAttribute("data-tunan-page")
      })
      lastRoute = route
    }

    injectCss()
    if (route === "/" || route.indexOf("/pages/tabbar/index/index") !== -1) renderHome(body)
    else if (route.indexOf("/pages/tabbar/classify/classify") !== -1) renderClassify(body)
    else if (route.indexOf("/pages/tabbar/study/study") !== -1) renderStudy(body)
    else if (route.indexOf("/pages/tabbar/mine/mine") !== -1) renderMine(body)
  }

  window.addEventListener("hashchange", function () { setTimeout(render, 120) })
  setInterval(render, 350)
  setTimeout(render, 200)
})()