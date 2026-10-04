<template>
	<view class="mine-page">
		<view class="profile-card">
			<view class="profile-top">
				<view class="avatar">
					<image v-if="profile.avatar" :src="profile.avatar" mode="aspectFill"></image>
					<text v-else>{{ initial }}</text>
				</view>
				<view class="profile-main">
					<view class="profile-name">{{ profile.nickname }}</view>
					<view class="profile-bio">{{ profile.bio }}</view>
					<view class="vip-tag">{{ profile.vipLevel }}</view>
				</view>
			</view>
			<view class="profile-stats">
				<view class="profile-stat">
					<text>{{ profile.studyDays }}</text>
					<view>学习天数</view>
				</view>
				<view class="profile-stat">
					<text>{{ profile.totalHours }}</text>
					<view>累计小时</view>
				</view>
				<view class="profile-stat">
					<text>{{ profile.stats.courseCount }}</text>
					<view>课程数</view>
				</view>
				<view class="profile-stat">
					<text>{{ profile.stats.finishedCourses }}</text>
					<view>已完成</view>
				</view>
			</view>
		</view>

		<view class="menu-card">
			<view class="menu-row" v-for="item in menus" :key="item.id" @click="openMenu(item)">
				<view class="menu-icon-wrap">
					<text class="icon iconfont menu-icon" :class="item.icon"></text>
				</view>
				<view class="menu-title">{{ item.title }}</view>
				<view class="menu-badge" v-if="item.badge">{{ item.badge }}</view>
				<text class="icon iconfont icon-right1 menu-arrow"></text>
			</view>
		</view>
	</view>
</template>

<script>
	import { request } from "../../../common/api.js"

	export default {
		data() {
			return {
				profile: {
					nickname: "兔南学员",
					avatar: "",
					bio: "",
					vipLevel: "普通学员",
					studyDays: 0,
					totalHours: 0,
					stats: {
						courseCount: 0,
						avgProgress: 0,
						learnedLessons: 0,
						finishedCourses: 0
					}
				},
				menus: []
			}
		},
		computed: {
			initial() {
				return (this.profile.nickname || "兔").slice(0, 1)
			}
		},
		mounted() {
			request({
				url: "/api/user/profile?userid=2162",
				success: res => {
					const data = res.data.data
					if (!data) return
					this.profile = data
					this.menus = data.menus || []
				},
				fail: () => {
					uni.showToast({ title: "个人资料加载失败", icon: "none" })
				}
			})
		},
		methods: {
			openMenu(item) {
				if (item.route) {
					uni.navigateTo({ url: item.route })
					return
				}
				uni.showToast({ title: item.title, icon: "none" })
			}
		}
	}
</script>

<style lang="scss">
	.mine-page {
		min-height: 100vh;
		box-sizing: border-box;
		padding: 20rpx 24rpx 40rpx;
		background: #f5f7f6;
	}

	.profile-card {
		overflow: hidden;
		border-radius: 28rpx;
		background: linear-gradient(135deg, #00b783 0%, #087f6b 100%);
		box-shadow: 0 16rpx 36rpx rgba(0, 167, 118, 0.2);
	}

	.profile-top {
		display: flex;
		align-items: center;
		padding: 38rpx 34rpx 30rpx;
	}

	.avatar {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 112rpx;
		height: 112rpx;
		overflow: hidden;
		border: 4rpx solid rgba(255, 255, 255, 0.45);
		border-radius: 50%;
		background: rgba(255, 255, 255, 0.2);
		color: #fff;
		font-size: 44rpx;
		font-weight: 700;

		image {
			width: 100%;
			height: 100%;
		}
	}

	.profile-main {
		flex: 1;
		min-width: 0;
		margin-left: 24rpx;
	}

	.profile-name {
		color: #fff;
		font-size: 36rpx;
		font-weight: 700;
	}

	.profile-bio {
		margin-top: 10rpx;
		color: rgba(255, 255, 255, 0.82);
		font-size: 23rpx;
	}

	.vip-tag {
		display: inline-block;
		margin-top: 14rpx;
		padding: 6rpx 16rpx;
		border-radius: 18rpx;
		background: rgba(255, 255, 255, 0.18);
		color: #fff;
		font-size: 20rpx;
	}

	.profile-stats {
		display: flex;
		padding: 24rpx 0 28rpx;
		background: rgba(0, 0, 0, 0.06);
	}

	.profile-stat {
		flex: 1;
		text-align: center;

		text {
			color: #fff;
			font-size: 30rpx;
			font-weight: 700;
		}

		view {
			margin-top: 6rpx;
			color: rgba(255, 255, 255, 0.76);
			font-size: 20rpx;
		}
	}

	.menu-card {
		margin-top: 26rpx;
		padding: 0 24rpx;
		border-radius: 24rpx;
		background: #fff;
		box-shadow: 0 10rpx 24rpx rgba(24, 48, 39, 0.06);
	}

	.menu-row {
		display: flex;
		align-items: center;
		height: 104rpx;
		border-bottom: 1px solid #f0f3f2;

		&:last-child {
			border-bottom: 0;
		}
	}

	.menu-icon-wrap {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 58rpx;
		height: 58rpx;
		border-radius: 18rpx;
		background: #edf9f5;
	}

	.menu-icon {
		color: #00a575;
		font-size: 28rpx;
	}

	.menu-title {
		flex: 1;
		margin-left: 20rpx;
		color: #1c2923;
		font-size: 27rpx;
	}

	.menu-badge {
		min-width: 32rpx;
		height: 32rpx;
		line-height: 32rpx;
		padding: 0 7rpx;
		border-radius: 16rpx;
		background: #ff5b52;
		color: #fff;
		font-size: 19rpx;
		text-align: center;
	}

	.menu-arrow {
		margin-left: 14rpx;
		color: #b7c0bc;
		font-size: 22rpx;
	}
</style>