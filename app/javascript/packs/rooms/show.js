import Vue from 'vue/dist/vue.esm';
import axios from 'axios';
axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')

var switchComponent = Vue.extend({
    template: '<button v-on:click="emitSwitch">切り替え</button>',
    methods: {
      emitSwitch: function() {
        this.$emit('switch')
      }
    }
});

new Vue({
  el: '#room-root',
  data: {
    chatDisplay: true,
    voteSelected: ""
  },
  created: function() {
    this.setInitialValue()
  },
  methods: {
    setVoteTarget(id) {
      axios.put('/api/v1/records/' + id, { record: { vote_target_id: this.voteSelected } })
        .then(res => {
          console.log(res.data)
        });
    },
    switchArea: function() {
      this.chatDisplay = !this.chatDisplay
    },
    setInitialValue: function() {
      this.voteSelected = document.getElementById('vote-initial').getAttribute('initial')
    }
  },
  components: {
    'switch-component': switchComponent
  }
});
