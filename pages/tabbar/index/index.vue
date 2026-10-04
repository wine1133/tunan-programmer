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
				foot_banner:""
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
		}
	}
</script>

<style>
	/* 在小程序和移动端中，非常推崇使用弹性盒子模型 */
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
