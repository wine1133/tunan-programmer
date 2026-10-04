<template>
	<view class="category-page">
		<view class="category-hero">
			<view class="hero-badge">COURSE CENTER</view>
			<view class="hero-title">选择你的学习方向</view>
			<view class="hero-desc">覆盖开发、数据、人工智能等热门技术</view>
		</view>

		<view class="section-title">
			<text>全部方向</text>
			<text class="section-count">{{ list.length }} 个分类</text>
		</view>

		<view class="category-grid">
			<view
				class="category-card"
				:class="'tone-' + (index % 4)"
				v-for="(item, index) in list"
				:key="item.id"
				@click="openCategory(item)"
			>
				<view class="category-icon-wrap">
					<text class="icon iconfont category-icon" :class="item.icon"></text>
				</view>
				<view class="category-name">{{ item.text }}</view>
				<view class="category-meta">查看课程</view>
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
		mounted() {
			request({
				url: "/api/index/nav",
				success: res => {
					this.list = res.data.data || []
				},
				fail: () => {
					uni.showToast({ title: "分类加载失败", icon: "none" })
				}
			})
		},
		methods: {
			openCategory(item) {
				uni.navigateTo({
					url: "/pages/course/courseIntroduce/courseIntroduce?id=" + item.id + "&course=" + item.course
				})
			}
		}
	}
</script>

<style lang="scss">
	.category-page {
		min-height: 100vh;
		box-sizing: border-box;
		padding: 20rpx 24rpx 40rpx;
		background: #f5f7f6;
	}

	.category-hero {
		position: relative;
		overflow: hidden;
		padding: 42rpx 36rpx;
		border-radius: 28rpx;
		background: linear-gradient(135deg, #00b783 0%, #087f6b 100%);
		box-shadow: 0 16rpx 36rpx rgba(0, 167, 118, 0.2);

		&::after {
			content: "";
			position: absolute;
			right: -80rpx;
			top: -100rpx;
			width: 260rpx;
			height: 260rpx;
			border-radius: 50%;
			background: rgba(255, 255, 255, 0.12);
		}
	}

	.hero-badge {
		display: inline-block;
		padding: 8rpx 18rpx;
		border-radius: 20rpx;
		background: rgba(255, 255, 255, 0.18);
		color: #fff;
		font-size: 20rpx;
		letter-spacing: 2rpx;
	}

	.hero-title {
		margin-top: 24rpx;
		color: #fff;
		font-size: 42rpx;
		font-weight: 700;
	}

	.hero-desc {
		margin-top: 14rpx;
		color: rgba(255, 255, 255, 0.86);
		font-size: 25rpx;
	}

	.section-title {
		display: flex;
		align-items: center;
		justify-content: space-between;
		margin: 38rpx 4rpx 22rpx;
		color: #17211d;
		font-size: 32rpx;
		font-weight: 700;
	}

	.section-count {
		color: #8b9691;
		font-size: 23rpx;
		font-weight: 400;
	}

	.category-grid {
		display: flex;
		flex-wrap: wrap;
		justify-content: space-between;
	}

	.category-card {
		width: calc(50% - 12rpx);
		box-sizing: border-box;
		margin-bottom: 24rpx;
		padding: 28rpx 22rpx 24rpx;
		border-radius: 24rpx;
		background: #fff;
		box-shadow: 0 10rpx 24rpx rgba(24, 48, 39, 0.06);
	}

	.category-icon-wrap {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 76rpx;
		height: 76rpx;
		border-radius: 24rpx;
		background: #e9f9f3;
	}

	.category-icon {
		color: #00a575;
		font-size: 38rpx;
	}

	.category-name {
		margin-top: 22rpx;
		color: #1c2923;
		font-size: 28rpx;
		font-weight: 600;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.category-meta {
		margin-top: 10rpx;
		color: #9aa39f;
		font-size: 22rpx;
	}

	.tone-1 .category-icon-wrap {
		background: #eef3ff;
	}

	.tone-1 .category-icon {
		color: #4078e8;
	}

	.tone-2 .category-icon-wrap {
		background: #fff4e8;
	}

	.tone-2 .category-icon {
		color: #df7d22;
	}

	.tone-3 .category-icon-wrap {
		background: #f8edff;
	}

	.tone-3 .category-icon {
		color: #8e4fd1;
	}
</style>