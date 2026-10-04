<template>
	<view>
		<NavBar />
		<view class="index_banner_box">
			<swiper class="swiper" :indicator-dots="true" :autoplay="true" :interval="4000" :duration="500">
				<swiper-item v-for="(item,index) in top_banner" :key="index">
					<image class="banner" :src="item.img_url"></image>
				</swiper-item>
			</swiper>
		</view>
		<view class="study-video-section" v-if="studyVideo.videoUrl">
			<view class="study-video-header">
				<view>
					<view class="study-video-title">{{ studyVideo.title }}</view>
					<view class="study-video-subtitle">{{ studyVideo.subtitle }}</view>
				</view>
				<view class="study-video-duration">{{ studyVideo.duration }} 秒</view>
			</view>
			<video class="study-video-player" :src="studyVideo.videoUrl" :poster="studyVideo.posterUrl" controls object-fit="cover"></video>
		</view>
		<CourseNav />
		<view class="online-box">
			<image class="online-img" :src="index_banner.img_url" mode=""></image>
		</view>
		<view class="free-box">
			<view class="free-box">
				<view class="public">
					限时免费
				</view>
			</view>
			<FreeCard />
		</view>
		<view class="public-title">
			<view class="public-class-t">零基础就业班</view>
			<JobScroll />
		</view>
		
		<view class="public-title">
			<view class="public">推荐课程</view>
			<CourseCard />
		</view>
		
		<view class="daotu_box">
			<view class="daotu_T">驱动教学——贯穿教 | 学 | 练 | 测 | 评</view>
			<image :src="foot_banner.img_url" mode=""></image>
		</view>
		
		
	</view>
</template>

<script>
	
	import { request } from "../../../common/api.js"
import NavBar from "../../../components/navbar/navbar.vue"
	import CourseNav from "../../../components/course-nav/course-nav.vue"
	import FreeCard from "../../../components/free-card/free-card.vue"
	import JobScroll from "../../../components/job-scroll/job-scroll.vue"
	import CourseCard from "../../../components/course-card/course-card.vue"
	
	export default {
		data() {
			return {
				top_banner:[],
				index_banner:"",
				foot_banner:"",
				studyVideo: {
					title: "",
					subtitle: "",
					videoUrl: "",
					posterUrl: "",
					duration: 0
				}
			}
		},
		components:{
			NavBar,
			CourseNav,
			FreeCard,
			JobScroll,
			CourseCard
		},
		methods: {
			
		},
		mounted(){
			request({
				url:"/api/index/banner",
				// success
				success:res =>{
					this.top_banner = res.data.top_banner
					this.index_banner = res.data.index_banner
					this.foot_banner = res.data.foot_banner
				}
			})

			request({
				url:"/api/index/video",
				success:res =>{
					if (res.data.data) {
						this.studyVideo = res.data.data
					}
				}
			})

		}
	}
</script>

<style>
	page {
		padding-bottom: 110rpx;
	}

	/* 在小程序和移动端中，非常推崇使用弹性盒子模型 */
	.study-video-section {
		margin: 8px 10px 18px;
		padding: 12px;
		border-radius: 14px;
		background: #fff;
		box-shadow: 0 5px 14px rgba(28, 50, 42, 0.08);
	}

	.study-video-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		margin-bottom: 10px;
	}

	.study-video-title {
		color: #17211d;
		font-size: 18px;
		font-weight: 700;
	}

	.study-video-subtitle {
		margin-top: 4px;
		color: #8f9995;
		font-size: 12px;
	}

	.study-video-duration {
		padding: 4px 10px;
		border-radius: 12px;
		background: #e9f9f3;
		color: #00a575;
		font-size: 11px;
	}

	.study-video-player {
		width: 100%;
		height: 190px;
		overflow: hidden;
		border-radius: 12px;
		background: #07110d;
	}
.index_banner_box{
		display: flex;
		width: 100%;
		padding: 10px;
		justify-content: center;
		align-items: center;
		border-radius: 5px;
		overflow: hidden;
	}
	
	.swiper{
		width: 100%;
		height: 260rpx;
	}
	
	.banner{
		width: 700rpx;
		height: 260rpx;
	}
	
	.online-box{
		display: flex;
		width: 724rpx;
		justify-content: center;
		align-items: center;
		overflow: hidden;
		margin-bottom: 15px;
	}
	
	.online-img{
		width: 724rpx;
		height: 132rpx;
	}
	
	.public{
		font-size: 20px;
		font-weight: 700;
	}

	.free-box{
		padding: 10px 5px;
	}
	
	.public-title{
		margin: 10px;
	}
	
	.public-class-t{
		font-size: 22px;
		font-weight: 700;
		margin-bottom: 15px;
	}
	
	.daotu_box{
		display: flex;
		box-sizing: border-box;
		flex-direction: column;
		justify-content: center;
		align-items: center;
	}
	
	.daotu_box .daotu_T{
		font-size: 18px;
		font-weight: 700;
		margin: 15px;
	}
	
	.daotu_box image{
		width: 699rpx;
		height: 634rpx;
		margin: 0 0 15px 0;
	}

</style>
