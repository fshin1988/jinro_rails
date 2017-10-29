import Vue from 'vue/dist/vue.esm';
import axios from 'axios';

const URL_BASE = 'http://localhost:3000/api/v1/rooms/';

new Vue({
  el: '.js-roomsIndex',
  data: {
    posts: {},
    postsDisplay: false
  },
  methods: {
    getPosts(id){
      axios.get(URL_BASE + id)
        .then(res => {
          this.posts = res.data;
          this.postsDisplay = true;
        });
    }
  }
});
