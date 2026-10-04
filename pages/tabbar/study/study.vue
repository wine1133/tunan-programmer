<template>
	<view class="study-page">
		<view class="study-hero">
			<view>
				<view class="study-kicker">MY LEARNING</view>
				<view class="study-title">继续学习</view>
				<view class="study-subtitle">今天也要向前进步一点</view>
			</view>
			<view class="study-medal">
				<text class="icon iconfont icon-xuexi"></text>
			</view>
		</view>

		<view class="summary-card">
			<view class="summary-item">
				<view class="summary-value">{{ list.length }}</view>
				<view class="summary-label">学习课程</view>
			</view>
			<view class="summary-divider"></view>
			<view class="summary-item">
				<view class="summary-value">{{ averageProgress }}%</view>
				<view class="summary-label">平均进度</view>
			</view>
			<view class="summary-divider"></view>
			<view class="summary-item">
				<view class="summary-value">{{ finishedCount }}</view>
				<view class="summary-label">已完成</view>
			</view>
		</view>

		<view class="section-head">
			<text>最近学习</text>
			<text class="section-tip">保持节奏</text>
		</view>

		<view class="study-list">
			<view class="study-card" v-for="item in list" :key="item.id" @click="continueStudy(item)">
				<image class="study-cover" :src="item.logo" mode="aspectFill"></image>
				<view class="study-info">
					<view class="study-name">{{ item.title }}</view>
					<view class="study-desc">{{ item.description }}</view>
					<view class="study-progress-row">
						<view class="study-progress">
							<view class="study-progress-inner" :style="{ width: item.progress + '%' }"></view>
						</view>
						<text class="study-percent">{{ item.progress }}%</text>
					</view>
					<view class="study-foot">
						<text>{{ item.learnedLessons }}/{{ item.totalLessons }} 节</text>
						<text>{{ item.lastStudyAt }}</text>
					</view>
				</view>
			</view>

			<view class="empty-state" v-if="list.length === 0">
				<text class="icon iconfont icon-kecheng empty-icon"></text>
				<view>暂无学习记录</view>
			</view>
		</view>
	</view>
</template>

<script>
	import { request } from "../../../common/api.js"

	export default {
		data() {
			return {
				list: []
			}
		},
		computed: {
			averageProgress() {
				if (this.list.length === 0) return 0
				const total = this.list.reduce((sum, item) => sum + item.progress, 0)
				return Math.round(total / this.list.length)
			},
			finishedCount() {
				return this.list.filter(item => item.status === "finished").length
			}
		},
		mounted() {
			request({
				url: "/api/study/list?userid=2162",
				success: res => {
					this.list = res.data.data || []
				},
				fail: () => {
					uni.showToast({ title: "学习记录加载失败", icon: "none" })
				}
			})
		},
		methods: {
			continueStudy(item) {
				uni.navigateTo({
					url: "/pages/course/courseIntroduce/courseIntroduce?id=" + item.courseId + "&course=yes"
				})
			}
		}
	}
</script>

<style lang="scss">
	.study-page {
		min-height: 100vh;
		box-sizing: border-box;
		padding: 20rpx 24rpx 120rpx;
		background: #f5f7f6;
	}

	.study-hero {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 38rpx 34rpx;
		border-radius: 28rpx;
		background: linear-gradient(135deg, #2f80ed 0%, #2458bd 100%);
		color: #fff;
		box-shadow: 0 16rpx 36rpx rgba(47, 128, 237, 0.22);
	}

	.study-kicker {
		font-size: 20rpx;
		letter-spacing: 2rpx;
		opacity: 0.75;
	}

	.study-title {
		margin-top: 16rpx;
		font-size: 42rpx;
		font-weight: 700;
	}

	.study-subtitle {
		margin-top: 10rpx;
		font-size: 24rpx;
		opacity: 0.86;
	}

	.study-medal {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 110rpx;
		height: 110rpx;
		border-radius: 50%;
		background: rgba(255, 255, 255, 0.16);

		text {
			font-size: 54rpx;
		}
	}

	.summary-card {
		display: flex;
		align-items: center;
		margin-top: -24rpx;
		margin-left: 24rpx;
		margin-right: 24rpx;
		padding: 26rpx 0;
		border-radius: 22rpx;
		background: #fff;
		box-shadow: 0 10rpx 28rpx rgba(28, 50, 42, 0.08);
	}

	.summary-item {
		flex: 1;
		text-align: center;
	}

	.summary-value {
		color: #17211d;
		font-size: 34rpx;
		font-weight: 700;
	}

	.summary-label {
		margin-top: 8rpx;
		color: #929d98;
		font-size: 21rpx;
	}

	.summary-divider {
		width: 1px;
		height: 52rpx;
		background: #edf1ef;
	}

	.section-head {
		display: flex;
		align-items: center;
		justify-content: space-between;
		margin: 38rpx 4rpx 20rpx;
		color: #17211d;
		font-size: 32rpx;
		font-weight: 700;
	}

	.section-tip {
		color: #9aa39f;
		font-size: 22rpx;
		font-weight: 400;
	}

	.study-card {
		display: flex;
		box-sizing: border-box;
		margin-bottom: 22rpx;
		padding: 22rpx;
		border-radius: 24rpx;
		background: #fff;
		box-shadow: 0 10rpx 24rpx rgba(24, 48, 39, 0.06);
	}

	.study-cover {
		flex-shrink: 0;
		width: 190rpx;
		height: 138rpx;
		border-radius: 18rpx;
		background: #eef2f0;
	}

	.study-info {
		flex: 1;
		min-width: 0;
		margin-left: 22rpx;
	}

	.study-name {
		color: #1c2923;
		font-size: 27rpx;
		font-weight: 600;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.study-desc {
		margin-top: 8rpx;
		color: #939e99;
		font-size: 21rpx;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.study-progress-row {
		display: flex;
		align-items: center;
		margin-top: 20rpx;
	}

	.study-progress {
		flex: 1;
		height: 12rpx;
		overflow: hidden;
		border-radius: 12rpx;
		background: #edf2f0;
	}

	.study-progress-inner {
		height: 100%;
		border-radius: 12rpx;
		background: linear-gradient(90deg, #00b783, #43cda5);
	}

	.study-percent {
		margin-left: 14rpx;
		color: #00a575;
		font-size: 22rpx;
		font-weight: 600;
	}

	.study-foot {
		display: flex;
		justify-content: space-between;
		margin-top: 14rpx;
		color: #9aa39f;
		font-size: 20rpx;
	}

	.empty-state {
		padding: 90rpx 0;
		text-align: center;
		color: #9aa39f;
		font-size: 25rpx;
	}

	.empty-icon {
		display: block;
		margin-bottom: 20rpx;
		color: #c2cbc7;
		font-size: 60rpx;
	}
</style>