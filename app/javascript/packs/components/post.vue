<template>
  <li class="left clearfix" v-if="owner == 'player'">
    <span class="chat-img pull-left">
      <span v-if="imageSrc">
        <img v-bind:src="imageSrc" class="avatar">
      </span>
      <span v-else>
        <i class="fa fa-user-circle-o default-user-icon"></i>
      </span>
    </span>
    <div class="chat-body clearfix">
      <div class="header">
        <strong class="chat-username">
          {{ username }}
        </strong>
        <small class="pull-right text-muted">
          {{ createdAt }}
        </small>
      </div>
      {{ content }}
    </div>
  </li>
  <li class="system clearfix" v-else>
    <div class="chat-body clearfix">
      {{ content }}
    </div>
  </li>
</template>

<script>
export default {
  props: ['post'],
  data: function() {
    return {
      owner: this.post.owner,
      username: this.post.username,
      createdAt: this.post.created_at,
      imageSrc: this.post.image_src,
      content: this.post.content,
    }
  }
}
</script>
